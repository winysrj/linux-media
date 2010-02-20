Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx05.extmail.prod.ext.phx2.redhat.com
	[10.5.110.9])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o1KBLjrf023933
	for <video4linux-list@redhat.com>; Sat, 20 Feb 2010 06:21:45 -0500
Received: from mail-yw0-f178.google.com (mail-yw0-f178.google.com
	[209.85.211.178])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o1KBLTiS015164
	for <video4linux-list@redhat.com>; Sat, 20 Feb 2010 06:21:29 -0500
Received: by ywh8 with SMTP id 8so867621ywh.6
	for <video4linux-list@redhat.com>; Sat, 20 Feb 2010 03:21:29 -0800 (PST)
Message-ID: <4B7FF69D.1080608@gmail.com>
Date: Sat, 20 Feb 2010 12:50:05 -0200
From: Guilherme <grlongo.ireland@gmail.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Subject: Re: ibv4l2: error requesting 4 buffers: Device or resource busy
References: <4B7FF5FC.1090403@gmail.com>
In-Reply-To: <4B7FF5FC.1090403@gmail.com>
Content-Type: multipart/mixed; boundary="------------050209050002040308050500"
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
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
--------------050209050002040308050500
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Guilherme wrote:
 Hi all!

 As I tried to migrate an applications that I had it working in another 
computer, I struggled to have it working here.
 It is a video capture application.
 The following error occurred:

 libv4l2: error requesting 4 buffers: Device or resource busy
 read error 16, Device or resource busy
 Press [Enter] to close the terminal ...

 The code is attached to this e-mail, plz can I get some help from here.
 Thanks a lot

P.S. My webcam works just fine on amsn.. so I guess its not a hardware 
dependant issue... Looking online for help, people say that the drive 
might be in use something related to this that is not my case.
 


--------------050209050002040308050500
Content-Type: text/plain;
 name="main.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="main.c"

/* 
 * File:   main.c
 * Author: guilherme
 *
 * Created on February 19, 2010, 11:48 AM
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <getopt.h>             /* getopt_long() */

#include <fcntl.h>              /* E/S de baixonivel */
#include <unistd.h>
#include <errno.h>
#include <malloc.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/time.h>
#include <sys/mman.h>
#include <sys/ioctl.h>
#include <asm/types.h>          /* p/ videodev2.h */
#include <linux/videodev2.h>
#include <libv4l2.h>


#include <math.h>
#include <ctype.h>



#define CLEAR(x) memset (&(x), 0, sizeof (x))


/*
 *
 */

typedef enum {
        IO_METHOD_READ,
        IO_METHOD_MMAP,
        IO_METHOD_USERPTR,
} io_method;

struct buffer {
        void *                  start;
        size_t                  length;
};

static char *           dev_name        = NULL;
static io_method        io              = IO_METHOD_READ;
static int              fd              = -1;
struct buffer *         buffers         = NULL;
static unsigned int     n_buffers       = 0;

int mask = 255;

static void
errno_exit                      (const char *           s)
{
        fprintf (stderr, "%s error %d, %s\n",
                 s, errno, strerror (errno));

        exit (EXIT_FAILURE);
}

static int
xioctl                          (int                    fd,
                                 int                    request,
                                 void *                 arg)
{
        int r;

        do r = v4l2_ioctl (fd, request, arg);
        while (-1 == r && EINTR == errno);

        return r;
}

int c = 0;


static void
process_image                   (const void * p)
{

   unsigned char *valor= (unsigned char *)p;
   int counti = 0;
   int i = 0;

  for(i = 0; i < 921600; i+=3) {

	  if(counti >= 0 && counti < 640) {
       int valorR = valor[i];
       printf("%i ", valorR);
       int valorG = valor[i+1];
       printf("%i ", valorG);
       int valorB = valor[i+2];
       printf("%i ", valorB);
       counti++;
	  }

	  if(counti == 640){
		 printf("\n");
		 counti = 0;
	  }
  }

   printf("\n\n *** FIM DO FRAME *** \n\n");

 }


static int
read_frame                      (void)
{

			// case IO_METHOD_READ:
                if (-1 == v4l2_read (fd, buffers[0].start, buffers[0].length)) {
                        switch (errno) {
                        case EAGAIN:
                                return 0;

                        case EIO:
                                /* Could ignore EIO, see spec. */

                                /* fall through */

                        default:
                                errno_exit ("read");
                        }
                }


               process_image (buffers[0].start);




        return 1;
}

static void
mainloop                        (void)
{
        unsigned int count;

        count = 1;

        while (count++ > 0) {
                for (;;) {
						/*
						 *
						 * Toda esta estrutura serve de controle caso queira adicionar mais fd.
						 * Isso implicaria em controle de I/0 com as bibliotecas pthread juntamente com
						 * o conjunto fd_set, FD_ZERO, FD_SET e select
						 *
						 */


                        fd_set fds;          //set de fd
                        struct timeval tv;   //define um estrutura timeval tv
                        int r;

                        FD_ZERO (&fds);      //Zera valores de fd_set
                        FD_SET (fd, &fds);   //Adiciona fd no set

                        /* Timeout. */
                        tv.tv_sec = 2;
                        tv.tv_usec = 0;

                        r = select (fd + 1, &fds, NULL, NULL, &tv);

                        if (-1 == r) {
                                if (EINTR == errno)
                                        continue;

                                errno_exit ("select");
                        }

                        if (0 == r) {
                                fprintf (stderr, "select timeout\n");
                                exit (EXIT_FAILURE);
                        }

                        if (read_frame ())
                                break;

                        /* EAGAIN - continue select loop. */
                }
        }
}


static void
uninit_device                   (void)
{
        unsigned int i;

        switch (io) {
        case IO_METHOD_READ:
                free (buffers[0].start);
                break;

        case IO_METHOD_MMAP:
                for (i = 0; i < n_buffers; ++i)
                        if (-1 == v4l2_munmap (buffers[i].start, buffers[i].length))
                                errno_exit ("munmap");
                break;

        case IO_METHOD_USERPTR:
                for (i = 0; i < n_buffers; ++i)
                        free (buffers[i].start);
                break;
        }

        free (buffers);
}

static void
init_read                       (unsigned int           buffer_size) //19.200
{
		//printf("Buffersize: %i\n", buffer_size);
        buffers = calloc (1, sizeof (*buffers)); // Reserva espaco para 1 estrutura buffer.

        if (!buffers) {
                fprintf (stderr, "Out of memory\n");
                exit (EXIT_FAILURE);
        }

       buffers[0].length = buffer_size;
       buffers[0].start = malloc (buffer_size);

        if (!buffers[0].start) {
                fprintf (stderr, "Out of memory\n");
                exit (EXIT_FAILURE);
        }
}


//Prepara dispositivo
static void
init_device                     (void)
{
        struct v4l2_capability cap;
        struct v4l2_cropcap cropcap;
        struct v4l2_crop crop;
        struct v4l2_format fmt;
        unsigned int min;

        if (-1 == xioctl (fd, VIDIOC_QUERYCAP, &cap)) {
                if (EINVAL == errno) {
                        fprintf (stderr, "%s is no V4L2 device\n",
                                 dev_name);
                        exit (EXIT_FAILURE);
                } else {
                        errno_exit ("VIDIOC_QUERYCAP");
                }
        }

        if (!(cap.capabilities & V4L2_CAP_VIDEO_CAPTURE)) {
                fprintf (stderr, "%s is no video capture device\n",
                         dev_name);
                exit (EXIT_FAILURE);
        }


        //case IO_METHOD_READ:
                if (!(cap.capabilities & V4L2_CAP_READWRITE)) {
                        fprintf (stderr, "%s does not support read i/o\n",
                                 dev_name);
                        exit (EXIT_FAILURE);
                }


        /* Select video input, video standard and tune here. */

        CLEAR (cropcap);

        cropcap.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;

        if (0 == xioctl (fd, VIDIOC_CROPCAP, &cropcap)) {
                crop.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
                crop.c = cropcap.defrect; /* reset to default */

                if (-1 == xioctl (fd, VIDIOC_S_CROP, &crop)) {
                        switch (errno) {
                        case EINVAL:
                                /* Cropping not supported. */
                                break;
                        default:
                                /* Errors ignored. */
                                break;
                        }
                }
        } else {
                /* Errors ignored. */
        }


        CLEAR (fmt);

        fmt.type                = V4L2_BUF_TYPE_VIDEO_CAPTURE;
        fmt.fmt.pix.width       = 640;
        fmt.fmt.pix.height      = 480;

        //fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_SN9C10X;
        //fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_SBGGR8;
        //fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_BGR24;
        fmt.fmt.pix.field       = V4L2_FIELD_INTERLACED;


        if (-1 == xioctl (fd, VIDIOC_S_FMT, &fmt))
                errno_exit ("VIDIOC_S_FMT");


						/* Buggy driver paranoia. */
		 printf("wi:%i  he:%i\n",fmt.fmt.pix.width, fmt.fmt.pix.height);
         min = fmt.fmt.pix.width * 1;
         printf("min: %i\n", min);
		 printf("pix: %i ", fmt.fmt.pix.pixelformat);
         printf("bp: %i\n", fmt.fmt.pix.bytesperline);
			 if (fmt.fmt.pix.bytesperline < min)
				 fmt.fmt.pix.bytesperline = min;
             min = fmt.fmt.pix.bytesperline * fmt.fmt.pix.height;
             printf("bp: %i   he: %i\n", fmt.fmt.pix.bytesperline, fmt.fmt.pix.height);
             if (fmt.fmt.pix.sizeimage < min)
            	 fmt.fmt.pix.sizeimage = min;
             printf("%i\n", fmt.fmt.pix.sizeimage);


        //case IO_METHOD_READ:
                init_read (fmt.fmt.pix.sizeimage);


}

static void
close_device                    (void)
{
        if (-1 == v4l2_close (fd))
                errno_exit ("close");

        fd = -1;
}

//Funcao que abre dispositivo
static void
open_device                     (void)
{
        struct stat st;

        if (-1 == stat (dev_name, &st)) {
                fprintf (stderr, "Cannot identify '%s': %d, %s\n",
                         dev_name, errno, strerror (errno));
                exit (EXIT_FAILURE);
        }

        if (!S_ISCHR (st.st_mode)) {
                fprintf (stderr, "%s is no device\n", dev_name);
                exit (EXIT_FAILURE);
        }

        fd = v4l2_open (dev_name, O_RDWR /* required */ | O_NONBLOCK, 0);

        if (-1 == fd) {
                fprintf (stderr, "Cannot open '%s': %d, %s\n",
                         dev_name, errno, strerror (errno));
                exit (EXIT_FAILURE);
        }
}


int
main                            (int                    argc,
                                 char **                argv)
{
        dev_name = "/dev/video0";

        open_device ();

        init_device ();  // -> Depois vai para init_read()

        mainloop (); // -> Chama read_frame();

        uninit_device ();

        close_device ();

        exit (EXIT_SUCCESS);

        return 0;
}





--------------050209050002040308050500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------050209050002040308050500--
