Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8CJMtGX000911
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 15:22:56 -0400
Received: from idcmail-mo2no.shaw.ca (idcmail-mo2no.shaw.ca [64.59.134.9])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8CJMihK013267
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 15:22:44 -0400
Message-ID: <48CAC180.5020005@ekran.org>
Date: Fri, 12 Sep 2008 12:22:40 -0700
From: "B. Bogart" <ben@ekran.org>
MIME-Version: 1.0
References: <48C05DC8.5060700@ekran.org>
	<1220568687.2736.12.camel@morgan.walls.org>
In-Reply-To: <1220568687.2736.12.camel@morgan.walls.org>
Content-Type: multipart/mixed; boundary="------------040800060304080508040203"
Cc: video4linux-list@redhat.com, gem-dev@iem.at
Subject: Re: Re: V4l2 :: Debugging an issue with cx8800 card.
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

This is a multi-part message in MIME format.
--------------040800060304080508040203
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

I have made progress.

I've managed to get my card working in Gem with some minor changes to
the code. I'm not sure what this code does though, so I'm not sure what
the longer term effect will be.

I'm sending this to the v4l list as you all are the best to advice on a
proper solution to this issue.

I've attached the original, and the hacked version.

Basically the hacked version ignores all errors when running the
following command:

xioctl (m_tvfd, VIDIOC_DQBUF, &buf)

What does this command actually do? Why are there two instances in the
capture function?

I can use the card at 640x480.

The result is the frame-rate is horrid compared to mplayer (which I
suppose makes sense based on those removed error reports) and also using
the V4L1 w/ a bt8x8 card.

Does this change give a hint as to what is causing the problem?

What is the proper way to fix the issue, rather than commenting out
error codes?

Thanks all,
B. Bogart


--------------040800060304080508040203
Content-Type: text/x-c++src;
 name="videoV4L2.cpp"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="videoV4L2.cpp"

////////////////////////////////////////////////////////
//
// GEM - Graphics Environment for Multimedia
//
// zmoelnig@iem.kug.ac.at
//
// Implementation file
//
//    Copyright (c) 1997-1998 Mark Danks.
//    Copyright (c) G�nther Geiger.
//    Copyright (c) 2001-2002 IOhannes m zmoelnig. forum::f�r::uml�ute. IEM
//    For information on usage and redistribution, and for a DISCLAIMER OF ALL
//    WARRANTIES, see the file, "GEM.LICENSE.TERMS" in this distribution.
//
/////////////////////////////////////////////////////////

#include "videoV4L2.h"

#if 0
# define debugPost post
# define debugThread post
#else
# define debugPost
# define debugThread
#endif

/////////////////////////////////////////////////////////
//
// videoV4L2
//
/////////////////////////////////////////////////////////
// Constructor
//
/////////////////////////////////////////////////////////
videoV4L2 :: videoV4L2(int format) : video(format)
#ifdef HAVE_VIDEO4LINUX2
                                   , m_gotFormat(0), m_colorConvert(0),
                                     m_tvfd(0),
                                     m_buffers(NULL), m_nbuffers(0), 
                                     m_currentBuffer(NULL),
                                     m_frame(0), m_last_frame(0),
                                     m_maxwidth(844), m_minwidth(32),
                                     m_maxheight(650), m_minheight(32),
                                     m_thread_id(0), m_continue_thread(false), m_frame_ready(false),
                                     m_rendering(false)
{
  if (!m_width)m_width=320;
  if (!m_height)m_height=240;
  m_capturing=false;
  m_devicenum=V4L2_DEVICENO;
  post("video4linux2");
#else
{
#endif /* HAVE_VIDEO4LINUX2 */
}
  
////////////////////////////////////////////////////////
// Destructor
//
////////////////////////////////////////////////////////
videoV4L2 :: ~videoV4L2()
{
#ifdef HAVE_VIDEO4LINUX2
  if (m_haveVideo)stopTransfer();
#endif /* HAVE_VIDEO4LINUX2 */
}

#ifdef HAVE_VIDEO4LINUX2
static int xioctl(int                    fd,
                  int                    request,
                  void *                 arg)
{
  int r;
     
  do {
    r = ioctl (fd, request, arg);
    debugThread("V4L2: xioctl %d->%d\n", r, errno);
  }
  while (-1 == r && EINTR == errno);

  debugThread("V4L2: xioctl done %d\n", r);
   
  return r;
}
 
int videoV4L2::init_mmap (void)
{
  struct v4l2_requestbuffers req;
  char*devname=(char*)((m_devicename)?m_devicename:"device");

  memset (&(req), 0, sizeof (req));

  req.count               = V4L2_NBUF;
  req.type                = V4L2_BUF_TYPE_VIDEO_CAPTURE;
  req.memory              = V4L2_MEMORY_MMAP;

  if (-1 == xioctl (m_tvfd, VIDIOC_REQBUFS, &req)) {
    if (EINVAL == errno) {
      error("%s does not support memory mapping", devname);
      return 0;
    } else {
      error ("VIDIOC_REQBUFS");
      return 0;
    }
  }

  if (req.count < V4L2_NBUF) {
    //error("Insufficient buffer memory on %s: %d", devname, req.count);
    //return(0);
  }

  m_buffers = (t_v4l2_buffer*)calloc (req.count, sizeof (*m_buffers));

  if (!m_buffers) {
    error("out of memory");
    return(0);
  }

  for (m_nbuffers = 0; m_nbuffers < req.count; ++m_nbuffers) {
    struct v4l2_buffer buf;

    memset (&(buf), 0, sizeof (buf));

    buf.type        = V4L2_BUF_TYPE_VIDEO_CAPTURE;
    buf.memory      = V4L2_MEMORY_MMAP;
    buf.index       = m_nbuffers;
    debugPost("v4l2: buf.index==%d", buf.index);

    if (-1 == xioctl (m_tvfd, VIDIOC_QUERYBUF, &buf)){
      error ("VIDIOC_QUERYBUF");
      return(0);
    }

    m_buffers[m_nbuffers].length = buf.length;
    m_buffers[m_nbuffers].start =
      mmap (NULL /* start anywhere */,
            buf.length,
            PROT_READ | PROT_WRITE /* required */,
            MAP_SHARED /* recommended */,
            m_tvfd, buf.m.offset);

    if (MAP_FAILED == m_buffers[m_nbuffers].start){
      error ("mmap");
      return 0;
    }
  }
  return 1;
}

/////////////////////////////////////////////////////////
// this is the work-horse
// a thread that does the capturing
//
/////////////////////////////////////////////////////////
void *videoV4L2 :: capturing(void*you)
{
  videoV4L2 *me=(videoV4L2 *)you;
  t_v4l2_buffer*buffers=me->m_buffers;

  struct v4l2_buffer buf;
  unsigned int i;
    
  fd_set fds;
  struct timeval tv;
  int r;

  int nbuf=me->m_nbuffers;
  int m_tvfd=me->m_tvfd;
  me->m_capturing=true;

  debugThread("V4L2: memset");
  memset(&(buf), 0, sizeof (buf));
  
  buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
  buf.memory = V4L2_MEMORY_MMAP;

  while(me->m_continue_thread){
    FD_ZERO (&fds);
    FD_SET (m_tvfd, &fds);

    debugThread("V4L2: grab");

    me->m_frame++;
    me->m_frame%=nbuf;

    
    /* Timeout. */
    tv.tv_sec = 0;
    tv.tv_usec = 100;

#if 0
    r = select (m_tvfd + 1, &fds, NULL, NULL, &tv);
      if (0 == r) {
      error("select timeout");
      me->m_continue_thread=false;
      }
#else
    r = select(0,0,0,0,&tv);
#endif
    debugThread("V4L2: waited...");
    if (-1 == r) {
      if (EINTR == errno)
        continue;
      error ("select");//exit
    }

    memset(&(buf), 0, sizeof (buf));
    debugThread("V4L2: memset...");
  
    buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
    buf.memory = V4L2_MEMORY_MMAP;

    if (-1 == xioctl (m_tvfd, VIDIOC_DQBUF, &buf)) {
      switch (errno) {
      case EAGAIN:
        perror("VIDIOC_DQBUF: stopping capture thread!");
        goto stop_capturethread;
      case EIO:
        /* Could ignore EIO, see spec. */
        /* fall through */
      default:
        perror ("VIDIOC_DQBUF");
      }
    }

    debugThread("V4L2: grabbed %d", buf.index);

    me->m_currentBuffer=buffers[buf.index].start;
    //process_image (m_buffers[buf.index].start);

    if (-1 == xioctl (m_tvfd, VIDIOC_QBUF, &buf)){
      perror ("VIDIOC_QBUF");
    }

    debugThread("V4L2: dequeueueeud");
    
    me->m_frame_ready = 1;
    me->m_last_frame=me->m_frame;
  }
 stop_capturethread:
  // stop capturing
  if(me->m_tvfd){
    enum v4l2_buf_type type;
    type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
    if (-1 == xioctl (me->m_tvfd, VIDIOC_STREAMOFF, &type)){
      perror ("VIDIOC_STREAMOFF");
    }
  }
  me->m_capturing=false;
  debugThread("V4L2: thread finished");
  return NULL;
}

//////////////////
// this reads the data that was captured by capturing() and returns it within a pixBlock
pixBlock *videoV4L2 :: getFrame(){
  if(!m_haveVideo)return NULL;
  //debugPost("v4l2: getting frame %d", m_frame_ready);
  m_image.newfilm=0;
  if (!m_frame_ready) m_image.newimage = 0;
  else {
    int i=0; // FIXME
    unsigned char*data=(unsigned char*)m_currentBuffer;
    if (m_colorConvert){
      m_image.image.notowned = false;
      switch(m_gotFormat){
      case V4L2_PIX_FMT_RGB24: m_image.image.fromRGB   (data); break;
      case V4L2_PIX_FMT_RGB32: m_image.image.fromRGBA  (data); break;
      case V4L2_PIX_FMT_GREY : m_image.image.fromGray  (data); break;
      case V4L2_PIX_FMT_UYVY : m_image.image.fromYUV422(data); break;
      case V4L2_PIX_FMT_YUV420:m_image.image.fromYU12(data); break;


      default: // ? what should we do ?
        m_image.image.data=data;
        m_image.image.notowned = true;
      }
    } else {
      m_image.image.data=data;
      m_image.image.notowned = true;
    }
    m_image.image.upsidedown=true;
    
    m_image.newimage = 1;
    m_frame_ready = false;
  }
  return &m_image;
}
/////////////////////////////////////////////////////////
// restartTransfer
//
/////////////////////////////////////////////////////////
void videoV4L2 :: restartTransfer()
{
  bool rendering=m_rendering;
  debugPost("v4l2: restart transfer");
  if(m_capturing)stopTransfer();
  debugPost("v4l2: restart stopped");
  if (rendering)startTransfer();
  debugPost("v4l2: restart started");
}


/////////////////////////////////////////////////////////
// startTransfer
//
/////////////////////////////////////////////////////////
int videoV4L2 :: startTransfer(int format)
{
  debugPost("v4l2: startTransfer: %d", m_capturing);
  if(m_capturing)stopTransfer(); // just in case we are already running!
  debugPost("v4l2: start transfer");
  m_rendering=true;
  if (format>1)m_reqFormat=format;
  //  verbose(1, "starting transfer");
  char buf[256];
  char*dev_name=m_devicename;
  int i;

  struct stat st; 
  struct v4l2_capability cap;
  struct v4l2_cropcap cropcap;
  struct v4l2_crop crop;
  struct v4l2_format fmt;
  unsigned int min;

  enum v4l2_buf_type type;

  m_frame = 0;
  m_last_frame = 0;


  /* check the device */

  // if we don't have a devicename, create one
  if(!dev_name){
    if (m_devicenum<0){
      sprintf(buf, "/dev/video");
    } else {
      sprintf(buf, "/dev/video%d", m_devicenum);
    }
    dev_name=buf;
  }

  // try to open the device
  debugPost("v4l2: device: %s", dev_name);
  
  m_tvfd = open (dev_name, O_RDWR /* required */ | O_NONBLOCK, 0);

  if (-1 == m_tvfd) {
    error("Cannot open '%s': %d, %s", dev_name, errno, strerror (errno));
    goto closit;
  }

  if (-1 == fstat (m_tvfd, &st)) {
    error("Cannot identify '%s': %d, %s", dev_name, errno, strerror (errno));
    goto closit;
  }

  if (!S_ISCHR (st.st_mode)) {
    error("%s is no device", dev_name);
    goto closit;
  }




  // by now, we have an open file-descriptor
  // check whether this is really a v4l2-device
  if (-1 == xioctl (m_tvfd, VIDIOC_QUERYCAP, &cap)) {
    if (EINVAL == errno) {
      error("%s is no V4L2 device",  dev_name);
      goto closit;
    } else {
      perror ("VIDIOC_QUERYCAP");//exit
      goto closit;
    }
  }

  if (!(cap.capabilities & V4L2_CAP_VIDEO_CAPTURE)) {
    error("%s is no video capture device", dev_name);
    goto closit;
  }

  if (!(cap.capabilities & V4L2_CAP_STREAMING)) {
    error("%s does not support streaming i/o", dev_name);
    goto closit;
  }

  /* Select video input, video standard and tune here. */

  cropcap.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;

  if (-1 == xioctl (m_tvfd, VIDIOC_CROPCAP, &cropcap)) {
    /* Errors ignored. */
  }

  memset(&(cropcap), 0, sizeof (cropcap));
  cropcap.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;

  if (0 == xioctl (m_tvfd, VIDIOC_CROPCAP, &cropcap)) {
    crop.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
    crop.c = cropcap.defrect; /* reset to default */

    if (-1 == xioctl (m_tvfd, VIDIOC_S_CROP, &crop)) {
      perror("vidioc_s_crop");
      switch (errno) {
      case EINVAL:
        /* Cropping not supported. */
        break;
      default:
        /* Errors ignored. */
        break;
      }
    }
  }


  if (-1 == xioctl (m_tvfd, VIDIOC_S_INPUT, &m_channel)) {
    perror("VIDIOC_S_INPUT"); /* exit */
  }

  memset (&(fmt), 0, sizeof (fmt));

  fmt.type                = V4L2_BUF_TYPE_VIDEO_CAPTURE;
  fmt.fmt.pix.width       = m_width;
  fmt.fmt.pix.height      = m_height;

  switch(m_reqFormat){
  case GL_YCBCR_422_GEM: 
    fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_UYVY; 
    break;
  case GL_LUMINANCE: 
    fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_GREY; 
    break;
  case GL_RGB: 
    fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_RGB24; 
    break;
  default: 
    fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_RGB32; 
    m_reqFormat=GL_RGBA;
    break;
  }
  fmt.fmt.pix.field       = V4L2_FIELD_INTERLACED;
  
  post("v4l2: wanted %d, got '%c%c%c%c' ", m_reqFormat, 
	    (char)(fmt.fmt.pix.pixelformat),
	    (char)(fmt.fmt.pix.pixelformat>>8),
	    (char)(fmt.fmt.pix.pixelformat>>16),
	    (char)(fmt.fmt.pix.pixelformat>>24));

  if (-1 == xioctl (m_tvfd, VIDIOC_S_FMT, &fmt)){
    perror ("VIDIOC_S_FMT");//exit
    error("should exit!");
  }
  
  // query back what we have set
  if (-1 == xioctl (m_tvfd, VIDIOC_G_FMT, &fmt)){
    perror ("VIDIOC_G_FMT");//exit
    error("should exit!");
  }

  m_gotFormat=fmt.fmt.pix.pixelformat;
  switch(m_gotFormat){
  case V4L2_PIX_FMT_RGB32: debugPost("v4l2: RGBA");break;
  case V4L2_PIX_FMT_UYVY: debugPost("v4l2: YUV ");break;
  case V4L2_PIX_FMT_GREY: debugPost("v4l2: gray");break;
  case V4L2_PIX_FMT_YUV420: debugPost("v4l2: YUV 4:2:0");break;
  default: error("unknown format '%c%c%c%c'",
		(char)(fmt.fmt.pix.pixelformat),
		(char)(fmt.fmt.pix.pixelformat>>8),
		(char)(fmt.fmt.pix.pixelformat>>16),
		(char)(fmt.fmt.pix.pixelformat>>24));

  }

  /* Note VIDIOC_S_FMT may change width and height. */
  if(m_width!=fmt.fmt.pix.width||m_height!=fmt.fmt.pix.height){
    post("v4l2: changed size from %dx%d to %dx%d", 
	 m_width, m_height,
	 fmt.fmt.pix.width,fmt.fmt.pix.height);
  }
  m_width =fmt.fmt.pix.width;
  m_height=fmt.fmt.pix.height;

  /* Buggy driver paranoia. */
  min = fmt.fmt.pix.width * 2;
  if (fmt.fmt.pix.bytesperline < min)
    fmt.fmt.pix.bytesperline = min;
  min = fmt.fmt.pix.bytesperline * fmt.fmt.pix.height;
  if (fmt.fmt.pix.sizeimage < min)
    fmt.fmt.pix.sizeimage = min;

  if(!init_mmap ())goto closit;

  for (i = 0; i < m_nbuffers; ++i) {
    struct v4l2_buffer buf;
    
    memset (&(buf), 0, sizeof (buf));
    
    buf.type        = V4L2_BUF_TYPE_VIDEO_CAPTURE;
    buf.memory      = V4L2_MEMORY_MMAP;
    buf.index       = i;
    
    if (-1 == xioctl (m_tvfd, VIDIOC_QBUF, &buf)){
      perror ("VIDIOC_QBUF");//exit
    }
  }

  type = V4L2_BUF_TYPE_VIDEO_CAPTURE;

  if (-1 == xioctl (m_tvfd, VIDIOC_STREAMON, &type)){
    perror ("VIDIOC_STREAMON");//exit
  }
  
  /* fill in image specifics for Gem pixel object.  Could we have
     just used RGB, I wonder? */
  m_image.image.xsize = m_width;
  m_image.image.ysize = m_height;
  m_image.image.setCsizeByFormat(m_reqFormat);
  m_image.image.reallocate();
  
  debugPost("v4l2: format: %c%c%c%c -> %d", 
       (char)(m_gotFormat),
       (char)(m_gotFormat>>8),
       (char)(m_gotFormat>>16),
       (char)(m_gotFormat>>24),
       m_reqFormat);
  switch(m_gotFormat){
  case V4L2_PIX_FMT_GREY  : m_colorConvert=(m_reqFormat!=GL_LUMINANCE); break;
  case V4L2_PIX_FMT_RGB24 : m_colorConvert=(m_reqFormat!=GL_RGB); break;
  case V4L2_PIX_FMT_RGB32 : m_colorConvert=(m_reqFormat!=GL_RGBA); break;//RGB32!=RGBA; is it ARGB or ABGR?
  case V4L2_PIX_FMT_UYVY  : m_colorConvert=(m_reqFormat!=GL_YCBCR_422_GEM); break;
  case V4L2_PIX_FMT_YUV420: m_colorConvert=1; break;
  default: m_colorConvert=true;
  }
  
  debugPost("v4l2: colorconvert=%d", m_colorConvert);
  
  m_haveVideo = 1;
  
  /* create thread */
  m_continue_thread = 1;
  m_frame_ready = 0;
  pthread_create(&m_thread_id, 0, capturing, this);
  while(!m_capturing){
    struct timeval sleep;
    sleep.tv_sec=0;  sleep.tv_usec=10; /* 10us */
    select(0,0,0,0,&sleep);
    debugPost("v4l2: waiting for thread to come up");
  }
  
  post("v4l2: GEM: pix_video: Opened video connection 0x%X", m_tvfd);
  
  return(1);
  
 closit:
  debugPost("v4l2: closing it!");
  stopTransfer();
  debugPost("v4l2: closed it");
  return(0);
}

/////////////////////////////////////////////////////////
// stopTransfer
//
/////////////////////////////////////////////////////////
int videoV4L2 :: stopTransfer()
{
  debugPost("v4l2: stoptransfer");
  int i=0;
  /* close the v4l2 device and dealloc buffer */
  /* terminate thread if there is one */
  if(m_continue_thread){
    void *dummy;
    m_continue_thread = 0;
    pthread_join (m_thread_id, &dummy);
  }
  while(m_capturing){
    struct timeval sleep;
    sleep.tv_sec=0;  sleep.tv_usec=10; /* 10us */
    select(0,0,0,0,&sleep);
    debugPost("v4l2: waiting for thread to finish");
  }

  // unmap the mmap
  debugPost("v4l2: unmapping %d buffers: %x", m_nbuffers, m_buffers);
  if(m_buffers){
    for (i = 0; i < m_nbuffers; ++i)
      if (-1 == munmap (m_buffers[i].start, m_buffers[i].length)){
        // oops: couldn't unmap the memory
      }
    debugPost("v4l2: freeing buffers: %x", m_buffers);
    free (m_buffers);
  }
  m_buffers=NULL;
  debugPost("v4l2: freed");

  // close the file-descriptor
  if (m_tvfd) close(m_tvfd);

  m_tvfd = 0;
  m_haveVideo = 0;
  m_frame_ready = 0;
  m_rendering=false;
  return(1);
}

/////////////////////////////////////////////////////////
// dimenMess
//
/////////////////////////////////////////////////////////
int videoV4L2 :: setDimen(int x, int y, int leftmargin, int rightmargin,
                          int topmargin, int bottommargin)
{
  int xtotal = x + leftmargin + rightmargin;
  int ytotal = y + topmargin + bottommargin;
  if (xtotal > m_maxwidth) /* 844 */
    error("x dimensions too great");
  else if (xtotal < m_minwidth || x < 1 || leftmargin < 0 || rightmargin < 0)
    error("x dimensions too small");
  if (ytotal > m_maxheight)
    error("y dimensions too great");
  else if (ytotal < m_minheight || y < 1 ||
           topmargin < 0 || bottommargin < 0)
    error("y dimensions too small");

  m_width=x;
  m_height=y;
  m_image.image.xsize = x;
  m_image.image.ysize = y;

  m_image.image.reallocate();
  restartTransfer();
  return 0;
}

int videoV4L2 :: setNorm(char*norm)
{
  char c=*norm;
  int i_norm=-1;

  switch (c){
  case 'p': case 'P':
    i_norm = V4L2_STD_PAL;
    break;
  case 'n': case 'N':
    i_norm = V4L2_STD_NTSC;
    break;
  case 's': case 'S':
    i_norm = V4L2_STD_SECAM;
    break;
  default:
    error("pix_video: unknown norm");
    return -1;
    break;
  }
  //  if (i_norm==m_norm)return 0;
  m_norm=i_norm;
  restartTransfer();
  return 0;
}

int videoV4L2 :: setChannel(int c, t_float f){
  error("v4l2: oops, no channel selection! please report this as a bug!!!");
  
  m_channel=c;
  
  restartTransfer();

  return 0;
}

int videoV4L2 :: setDevice(int d)
{
  m_devicename=NULL;
  if (d==m_devicenum)return 0;
  m_devicenum=d;
  restartTransfer();
  //  verbose(1, "new device set %d", m_devicenum);
  return 0;
}
int videoV4L2 :: setDevice(char*name)
{
  m_devicenum=-1;
  m_devicename=name;
  restartTransfer();
  //  verbose(1, "new device set %d", m_devicenum);
  return 0;
}

int videoV4L2 :: setColor(int format)
{
  if (format<=0 || format==m_reqFormat)return -1;
  m_reqFormat=format;
  restartTransfer();
  return 0;
}
#endif /* HAVE_VIDEO4LINUX2 */

--------------040800060304080508040203
Content-Type: text/x-c++src;
 name="videoV4L2-hacked.cpp"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="videoV4L2-hacked.cpp"

////////////////////////////////////////////////////////
//
// GEM - Graphics Environment for Multimedia
//
// zmoelnig@iem.kug.ac.at
//
// Implementation file
//
//    Copyright (c) 1997-1998 Mark Danks.
//    Copyright (c) G�nther Geiger.
//    Copyright (c) 2001-2002 IOhannes m zmoelnig. forum::f�r::uml�ute. IEM
//    For information on usage and redistribution, and for a DISCLAIMER OF ALL
//    WARRANTIES, see the file, "GEM.LICENSE.TERMS" in this distribution.
//
/////////////////////////////////////////////////////////

#include "videoV4L2.h"

#if 0
# define debugPost post
# define debugThread post
#else
# define debugPost
# define debugThread
#endif

/////////////////////////////////////////////////////////
//
// videoV4L2
//
/////////////////////////////////////////////////////////
// Constructor
//
/////////////////////////////////////////////////////////
videoV4L2 :: videoV4L2(int format) : video(format)
#ifdef HAVE_VIDEO4LINUX2
                                   , m_gotFormat(0), m_colorConvert(0),
                                     m_tvfd(0),
                                     m_buffers(NULL), m_nbuffers(0), 
                                     m_currentBuffer(NULL),
                                     m_frame(0), m_last_frame(0),
                                     m_maxwidth(844), m_minwidth(32),
                                     m_maxheight(650), m_minheight(32),
                                     m_thread_id(0), m_continue_thread(false), m_frame_ready(false),
                                     m_rendering(false)
{
  if (!m_width)m_width=320;
  if (!m_height)m_height=240;
  m_capturing=false;
  m_devicenum=V4L2_DEVICENO;
  post("video4linux2");
#else
{
#endif /* HAVE_VIDEO4LINUX2 */
}
  
////////////////////////////////////////////////////////
// Destructor
//
////////////////////////////////////////////////////////
videoV4L2 :: ~videoV4L2()
{
#ifdef HAVE_VIDEO4LINUX2
  if (m_haveVideo)stopTransfer();
#endif /* HAVE_VIDEO4LINUX2 */
}

#ifdef HAVE_VIDEO4LINUX2
static int xioctl(int                    fd,
                  int                    request,
                  void *                 arg)
{
  int r;
     
  do {
    r = ioctl (fd, request, arg);
    debugThread("V4L2: xioctl %d->%d\n", r, errno);
  }
  while (-1 == r && EINTR == errno);

  debugThread("V4L2: xioctl done %d\n", r);
   
  return r;
}
 
int videoV4L2::init_mmap (void)
{
  struct v4l2_requestbuffers req;
  char*devname=(char*)((m_devicename)?m_devicename:"device");

  memset (&(req), 0, sizeof (req));

  req.count               = V4L2_NBUF;
  req.type                = V4L2_BUF_TYPE_VIDEO_CAPTURE;
  req.memory              = V4L2_MEMORY_MMAP;

  if (-1 == xioctl (m_tvfd, VIDIOC_REQBUFS, &req)) {
    if (EINVAL == errno) {
      error("%s does not support memory mapping", devname);
      return 0;
    } else {
      error ("VIDIOC_REQBUFS");
      return 0;
    }
  }

  if (req.count < V4L2_NBUF) {
    //error("Insufficient buffer memory on %s: %d", devname, req.count);
    //return(0);
  }

  m_buffers = (t_v4l2_buffer*)calloc (req.count, sizeof (*m_buffers));

  if (!m_buffers) {
    error("out of memory");
    return(0);
  }

  for (m_nbuffers = 0; m_nbuffers < req.count; ++m_nbuffers) {
    struct v4l2_buffer buf;

    memset (&(buf), 0, sizeof (buf));

    buf.type        = V4L2_BUF_TYPE_VIDEO_CAPTURE;
    buf.memory      = V4L2_MEMORY_MMAP;
    buf.index       = m_nbuffers;
    debugPost("v4l2: buf.index==%d", buf.index);

    if (-1 == xioctl (m_tvfd, VIDIOC_QUERYBUF, &buf)){
      error ("VIDIOC_QUERYBUF");
      return(0);
    }

    m_buffers[m_nbuffers].length = buf.length;
    m_buffers[m_nbuffers].start =
      mmap (NULL /* start anywhere */,
            buf.length,
            PROT_READ | PROT_WRITE /* required */,
            MAP_SHARED /* recommended */,
            m_tvfd, buf.m.offset);

    if (MAP_FAILED == m_buffers[m_nbuffers].start){
      error ("mmap");
      return 0;
    }
  }
  return 1;
}

/////////////////////////////////////////////////////////
// this is the work-horse
// a thread that does the capturing
//
/////////////////////////////////////////////////////////
void *videoV4L2 :: capturing(void*you)
{
  videoV4L2 *me=(videoV4L2 *)you;
  t_v4l2_buffer*buffers=me->m_buffers;

  struct v4l2_buffer buf;
  unsigned int i;
    
  fd_set fds;
  struct timeval tv;
  int r;

  int nbuf=me->m_nbuffers;
  int m_tvfd=me->m_tvfd;
  me->m_capturing=true;

  debugThread("V4L2: memset");
  memset(&(buf), 0, sizeof (buf));
  
  buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
  buf.memory = V4L2_MEMORY_MMAP;

  while(me->m_continue_thread){
    FD_ZERO (&fds);
    FD_SET (m_tvfd, &fds);

    debugThread("V4L2: grab");

    me->m_frame++;
    me->m_frame%=nbuf;

    
    /* Timeout. */
    tv.tv_sec = 0;
    tv.tv_usec = 100;

#if 0
    r = select (m_tvfd + 1, &fds, NULL, NULL, &tv);
      if (0 == r) {
      error("select timeout");
      me->m_continue_thread=false;
      }
#else
    r = select(0,0,0,0,&tv);
#endif
    debugThread("V4L2: waited...");
    if (-1 == r) {
      if (EINTR == errno)
        continue;
      error ("select");//exit
    }

    memset(&(buf), 0, sizeof (buf));
    debugThread("V4L2: memset...");
  
    buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
    buf.memory = V4L2_MEMORY_MMAP;

    if (-1 == xioctl (m_tvfd, VIDIOC_DQBUF, &buf)) {
/*      switch (errno) {
      case EAGAIN:
        perror("VIDIOC_DQBUF: stopping capture thread!");
        goto stop_capturethread;
      case EIO:
        /* Could ignore EIO, see spec. bb/
        /* fall through bb/
      default:
        perror ("VIDIOC_DQBUF");
      }*/
    }

    debugThread("V4L2: grabbed %d", buf.index);

    me->m_currentBuffer=buffers[buf.index].start;
    //process_image (m_buffers[buf.index].start);

    if (-1 == xioctl (m_tvfd, VIDIOC_QBUF, &buf)){
      //perror ("VIDIOC_QBUF");
    }

    debugThread("V4L2: dequeueueeud");
    
    me->m_frame_ready = 1;
    me->m_last_frame=me->m_frame;
  }
 stop_capturethread:
  // stop capturing
  if(me->m_tvfd){
    enum v4l2_buf_type type;
    type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
    if (-1 == xioctl (me->m_tvfd, VIDIOC_STREAMOFF, &type)){
      perror ("VIDIOC_STREAMOFF");
    }
  }
  me->m_capturing=false;
  debugThread("V4L2: thread finished");
  return NULL;
}

//////////////////
// this reads the data that was captured by capturing() and returns it within a pixBlock
pixBlock *videoV4L2 :: getFrame(){
  if(!m_haveVideo)return NULL;
  //debugPost("v4l2: getting frame %d", m_frame_ready);
  m_image.newfilm=0;
  if (!m_frame_ready) m_image.newimage = 0;
  else {
    int i=0; // FIXME
    unsigned char*data=(unsigned char*)m_currentBuffer;
    if (m_colorConvert){
      m_image.image.notowned = false;
      switch(m_gotFormat){
      case V4L2_PIX_FMT_RGB24: m_image.image.fromRGB   (data); break;
      case V4L2_PIX_FMT_RGB32: m_image.image.fromRGBA  (data); break;
      case V4L2_PIX_FMT_GREY : m_image.image.fromGray  (data); break;
      case V4L2_PIX_FMT_UYVY : m_image.image.fromYUV422(data); break;
      case V4L2_PIX_FMT_YUV420:m_image.image.fromYU12(data); break;


      default: // ? what should we do ?
        m_image.image.data=data;
        m_image.image.notowned = true;
      }
    } else {
      m_image.image.data=data;
      m_image.image.notowned = true;
    }
    m_image.image.upsidedown=true;
    
    m_image.newimage = 1;
    m_frame_ready = false;
  }
  return &m_image;
}
/////////////////////////////////////////////////////////
// restartTransfer
//
/////////////////////////////////////////////////////////
void videoV4L2 :: restartTransfer()
{
  bool rendering=m_rendering;
  debugPost("v4l2: restart transfer");
  if(m_capturing)stopTransfer();
  debugPost("v4l2: restart stopped");
  if (rendering)startTransfer();
  debugPost("v4l2: restart started");
}


/////////////////////////////////////////////////////////
// startTransfer
//
/////////////////////////////////////////////////////////
int videoV4L2 :: startTransfer(int format)
{
  debugPost("v4l2: startTransfer: %d", m_capturing);
  if(m_capturing)stopTransfer(); // just in case we are already running!
  debugPost("v4l2: start transfer");
  m_rendering=true;
  if (format>1)m_reqFormat=format;
  //  verbose(1, "starting transfer");
  char buf[256];
  char*dev_name=m_devicename;
  int i;

  struct stat st; 
  struct v4l2_capability cap;
  struct v4l2_cropcap cropcap;
  struct v4l2_crop crop;
  struct v4l2_format fmt;
  unsigned int min;

  enum v4l2_buf_type type;

  m_frame = 0;
  m_last_frame = 0;


  /* check the device */

  // if we don't have a devicename, create one
  if(!dev_name){
    if (m_devicenum<0){
      sprintf(buf, "/dev/video");
    } else {
      sprintf(buf, "/dev/video%d", m_devicenum);
    }
    dev_name=buf;
  }

  // try to open the device
  debugPost("v4l2: device: %s", dev_name);
  
  m_tvfd = open (dev_name, O_RDWR /* required */ | O_NONBLOCK, 0);

  if (-1 == m_tvfd) {
    error("Cannot open '%s': %d, %s", dev_name, errno, strerror (errno));
    goto closit;
  }

  if (-1 == fstat (m_tvfd, &st)) {
    error("Cannot identify '%s': %d, %s", dev_name, errno, strerror (errno));
    goto closit;
  }

  if (!S_ISCHR (st.st_mode)) {
    error("%s is no device", dev_name);
    goto closit;
  }




  // by now, we have an open file-descriptor
  // check whether this is really a v4l2-device
  if (-1 == xioctl (m_tvfd, VIDIOC_QUERYCAP, &cap)) {
    if (EINVAL == errno) {
      error("%s is no V4L2 device",  dev_name);
      goto closit;
    } else {
      perror ("VIDIOC_QUERYCAP");//exit
      goto closit;
    }
  }

  if (!(cap.capabilities & V4L2_CAP_VIDEO_CAPTURE)) {
    error("%s is no video capture device", dev_name);
    goto closit;
  }

  if (!(cap.capabilities & V4L2_CAP_STREAMING)) {
    error("%s does not support streaming i/o", dev_name);
    goto closit;
  }

  /* Select video input, video standard and tune here. */

  cropcap.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;

  if (-1 == xioctl (m_tvfd, VIDIOC_CROPCAP, &cropcap)) {
    /* Errors ignored. */
  }

  memset(&(cropcap), 0, sizeof (cropcap));
  cropcap.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;

  if (0 == xioctl (m_tvfd, VIDIOC_CROPCAP, &cropcap)) {
    crop.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
    crop.c = cropcap.defrect; /* reset to default */

    if (-1 == xioctl (m_tvfd, VIDIOC_S_CROP, &crop)) {
      perror("vidioc_s_crop");
      switch (errno) {
      case EINVAL:
        /* Cropping not supported. */
        break;
      default:
        /* Errors ignored. */
        break;
      }
    }
  }


  if (-1 == xioctl (m_tvfd, VIDIOC_S_INPUT, &m_channel)) {
    perror("VIDIOC_S_INPUT"); /* exit */
  }

  memset (&(fmt), 0, sizeof (fmt));

  fmt.type                = V4L2_BUF_TYPE_VIDEO_CAPTURE;
  fmt.fmt.pix.width       = m_width;
  fmt.fmt.pix.height      = m_height;

  switch(m_reqFormat){
  case GL_YCBCR_422_GEM: 
    fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_UYVY; 
    break;
  case GL_LUMINANCE: 
    fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_GREY; 
    break;
  case GL_RGB: 
    fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_RGB24; 
    break;
  default: 
    fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_RGB32; 
    m_reqFormat=GL_RGBA;
    break;
  }
  fmt.fmt.pix.field       = V4L2_FIELD_INTERLACED;
  
  post("v4l2: wanted %d, got '%c%c%c%c' ", m_reqFormat, 
	    (char)(fmt.fmt.pix.pixelformat),
	    (char)(fmt.fmt.pix.pixelformat>>8),
	    (char)(fmt.fmt.pix.pixelformat>>16),
	    (char)(fmt.fmt.pix.pixelformat>>24));

  if (-1 == xioctl (m_tvfd, VIDIOC_S_FMT, &fmt)){
    perror ("VIDIOC_S_FMT");//exit
    error("should exit!");
  }
  
  // query back what we have set
  if (-1 == xioctl (m_tvfd, VIDIOC_G_FMT, &fmt)){
    perror ("VIDIOC_G_FMT");//exit
    error("should exit!");
  }

  m_gotFormat=fmt.fmt.pix.pixelformat;
  switch(m_gotFormat){
  case V4L2_PIX_FMT_RGB32: debugPost("v4l2: RGBA");break;
  case V4L2_PIX_FMT_UYVY: debugPost("v4l2: YUV ");break;
  case V4L2_PIX_FMT_GREY: debugPost("v4l2: gray");break;
  case V4L2_PIX_FMT_YUV420: debugPost("v4l2: YUV 4:2:0");break;
  default: error("unknown format '%c%c%c%c'",
		(char)(fmt.fmt.pix.pixelformat),
		(char)(fmt.fmt.pix.pixelformat>>8),
		(char)(fmt.fmt.pix.pixelformat>>16),
		(char)(fmt.fmt.pix.pixelformat>>24));

  }

  /* Note VIDIOC_S_FMT may change width and height. */
  if(m_width!=fmt.fmt.pix.width||m_height!=fmt.fmt.pix.height){
    post("v4l2: changed size from %dx%d to %dx%d", 
	 m_width, m_height,
	 fmt.fmt.pix.width,fmt.fmt.pix.height);
  }
  m_width =fmt.fmt.pix.width;
  m_height=fmt.fmt.pix.height;

  /* Buggy driver paranoia. */
  min = fmt.fmt.pix.width * 2;
  if (fmt.fmt.pix.bytesperline < min)
    fmt.fmt.pix.bytesperline = min;
  min = fmt.fmt.pix.bytesperline * fmt.fmt.pix.height;
  if (fmt.fmt.pix.sizeimage < min)
    fmt.fmt.pix.sizeimage = min;

  if(!init_mmap ())goto closit;

  for (i = 0; i < m_nbuffers; ++i) {
    struct v4l2_buffer buf;
    
    memset (&(buf), 0, sizeof (buf));
    
    buf.type        = V4L2_BUF_TYPE_VIDEO_CAPTURE;
    buf.memory      = V4L2_MEMORY_MMAP;
    buf.index       = i;
    
    if (-1 == xioctl (m_tvfd, VIDIOC_QBUF, &buf)){
      perror ("VIDIOC_QBUF");//exit
    }
  }

  type = V4L2_BUF_TYPE_VIDEO_CAPTURE;

  if (-1 == xioctl (m_tvfd, VIDIOC_STREAMON, &type)){
    perror ("VIDIOC_STREAMON");//exit
  }
  
  /* fill in image specifics for Gem pixel object.  Could we have
     just used RGB, I wonder? */
  m_image.image.xsize = m_width;
  m_image.image.ysize = m_height;
  m_image.image.setCsizeByFormat(m_reqFormat);
  m_image.image.reallocate();
  
  debugPost("v4l2: format: %c%c%c%c -> %d", 
       (char)(m_gotFormat),
       (char)(m_gotFormat>>8),
       (char)(m_gotFormat>>16),
       (char)(m_gotFormat>>24),
       m_reqFormat);
  switch(m_gotFormat){
  case V4L2_PIX_FMT_GREY  : m_colorConvert=(m_reqFormat!=GL_LUMINANCE); break;
  case V4L2_PIX_FMT_RGB24 : m_colorConvert=(m_reqFormat!=GL_RGB); break;
  case V4L2_PIX_FMT_RGB32 : m_colorConvert=(m_reqFormat!=GL_RGBA); break;//RGB32!=RGBA; is it ARGB or ABGR?
  case V4L2_PIX_FMT_UYVY  : m_colorConvert=(m_reqFormat!=GL_YCBCR_422_GEM); break;
  case V4L2_PIX_FMT_YUV420: m_colorConvert=1; break;
  default: m_colorConvert=true;
  }
  
  debugPost("v4l2: colorconvert=%d", m_colorConvert);
  
  m_haveVideo = 1;
  
  /* create thread */
  m_continue_thread = 1;
  m_frame_ready = 0;
  pthread_create(&m_thread_id, 0, capturing, this);
  while(!m_capturing){
    struct timeval sleep;
    sleep.tv_sec=0;  sleep.tv_usec=10; /* 10us */
    select(0,0,0,0,&sleep);
    debugPost("v4l2: waiting for thread to come up");
  }
  
  post("v4l2: GEM: pix_video: Opened video connection 0x%X", m_tvfd);
  
  return(1);
  
 closit:
  debugPost("v4l2: closing it!");
  stopTransfer();
  debugPost("v4l2: closed it");
  return(0);
}

/////////////////////////////////////////////////////////
// stopTransfer
//
/////////////////////////////////////////////////////////
int videoV4L2 :: stopTransfer()
{
  debugPost("v4l2: stoptransfer");
  int i=0;
  /* close the v4l2 device and dealloc buffer */
  /* terminate thread if there is one */
  if(m_continue_thread){
    void *dummy;
    m_continue_thread = 0;
    pthread_join (m_thread_id, &dummy);
  }
  while(m_capturing){
    struct timeval sleep;
    sleep.tv_sec=0;  sleep.tv_usec=10; /* 10us */
    select(0,0,0,0,&sleep);
    debugPost("v4l2: waiting for thread to finish");
  }

  // unmap the mmap
  debugPost("v4l2: unmapping %d buffers: %x", m_nbuffers, m_buffers);
  if(m_buffers){
    for (i = 0; i < m_nbuffers; ++i)
      if (-1 == munmap (m_buffers[i].start, m_buffers[i].length)){
        // oops: couldn't unmap the memory
      }
    debugPost("v4l2: freeing buffers: %x", m_buffers);
    free (m_buffers);
  }
  m_buffers=NULL;
  debugPost("v4l2: freed");

  // close the file-descriptor
  if (m_tvfd) close(m_tvfd);

  m_tvfd = 0;
  m_haveVideo = 0;
  m_frame_ready = 0;
  m_rendering=false;
  return(1);
}

/////////////////////////////////////////////////////////
// dimenMess
//
/////////////////////////////////////////////////////////
int videoV4L2 :: setDimen(int x, int y, int leftmargin, int rightmargin,
                          int topmargin, int bottommargin)
{
  int xtotal = x + leftmargin + rightmargin;
  int ytotal = y + topmargin + bottommargin;
  if (xtotal > m_maxwidth) /* 844 */
    error("x dimensions too great");
  else if (xtotal < m_minwidth || x < 1 || leftmargin < 0 || rightmargin < 0)
    error("x dimensions too small");
  if (ytotal > m_maxheight)
    error("y dimensions too great");
  else if (ytotal < m_minheight || y < 1 ||
           topmargin < 0 || bottommargin < 0)
    error("y dimensions too small");

  m_width=x;
  m_height=y;
  m_image.image.xsize = x;
  m_image.image.ysize = y;

  m_image.image.reallocate();
  restartTransfer();
  return 0;
}

int videoV4L2 :: setNorm(char*norm)
{
  char c=*norm;
  int i_norm=-1;

  switch (c){
  case 'p': case 'P':
    i_norm = V4L2_STD_PAL;
    break;
  case 'n': case 'N':
    i_norm = V4L2_STD_NTSC;
    break;
  case 's': case 'S':
    i_norm = V4L2_STD_SECAM;
    break;
  default:
    error("pix_video: unknown norm");
    return -1;
    break;
  }
  //  if (i_norm==m_norm)return 0;
  m_norm=i_norm;
  restartTransfer();
  return 0;
}

int videoV4L2 :: setChannel(int c, t_float f){
  error("v4l2: oops, no channel selection! please report this as a bug!!!");
  
  m_channel=c;
  
  restartTransfer();

  return 0;
}

int videoV4L2 :: setDevice(int d)
{
  m_devicename=NULL;
  if (d==m_devicenum)return 0;
  m_devicenum=d;
  restartTransfer();
  //  verbose(1, "new device set %d", m_devicenum);
  return 0;
}
int videoV4L2 :: setDevice(char*name)
{
  m_devicenum=-1;
  m_devicename=name;
  restartTransfer();
  //  verbose(1, "new device set %d", m_devicenum);
  return 0;
}

int videoV4L2 :: setColor(int format)
{
  if (format<=0 || format==m_reqFormat)return -1;
  m_reqFormat=format;
  restartTransfer();
  return 0;
}
#endif /* HAVE_VIDEO4LINUX2 */

--------------040800060304080508040203
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------040800060304080508040203--
