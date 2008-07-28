Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6SLngJ4003073
	for <video4linux-list@redhat.com>; Mon, 28 Jul 2008 17:49:42 -0400
Received: from aragorn.vidconference.de (dns.vs-node3.de [87.106.12.105])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6SLnUTO027700
	for <video4linux-list@redhat.com>; Mon, 28 Jul 2008 17:49:30 -0400
Date: Mon, 28 Jul 2008 23:49:27 +0200
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Message-ID: <20080728214927.GA21280@vidsoft.de>
References: <488721F2.5000509@hhs.nl>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <488721F2.5000509@hhs.nl>
From: Gregor Jasny <jasny@vidsoft.de>
Cc: video4linux-list@redhat.com, v4l2 library <v4l2-library@linuxtv.org>,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>
Subject: Messed up syscall return value
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


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I've observed strange behavior in the REQBUFS ioctl for the non-emulated
case. To reproduce:
* Use a amd64 system (Debian Sid if it matters)
* Linux 2.6.26
* load vivi driver to video0
* Compile attached program w/o libv4l2 and check that it runs fine.
* Compile attached program with libv4l2 and see it fail during REQBUFS
  ioctl.

I've debugged the problem to the line:
result = syscall(SYS_ioctl, devices[index].fd, VIDIOC_REQBUFS, req);

Here the value 2 get stored into result, although the kernel driver
returned success (at least it does not complain loudly in the logs).

When stepping assembly instructions the rax value is zero, shortly after
it is set to two. Personally I suspect a messed up stack. Both
v4l2_ioctl and syscall are variable argument functions.

Thanks,
Gregor

Kernel log for pure V4L2;
Jul 28 23:20:09 Rincewind kernel: vivi: open called (minor=0)
Jul 28 23:20:09 Rincewind kernel: vivi: open minor=0 type=video-cap users=1
Jul 28 23:20:09 Rincewind kernel: vivi: vivi_start_thread
Jul 28 23:20:09 Rincewind kernel: vivi: returning from vivi_start_thread
Jul 28 23:20:09 Rincewind kernel: vivi: thread started
Jul 28 23:20:09 Rincewind kernel: vivi: vivi_sleep dma_q=0xffff81005c480640
Jul 28 23:20:09 Rincewind kernel: vivi: Thread tick
Jul 28 23:20:09 Rincewind kernel: vivi: No active queue to serve
Jul 28 23:20:09 Rincewind kernel: vivi (0): VIDIOC_S_FMT
Jul 28 23:20:09 Rincewind kernel: vivi (0): VIDIOC_REQBUFS
Jul 28 23:20:09 Rincewind kernel: vivi: buffer_setup, count=2, size=202752
Jul 28 23:20:09 Rincewind kernel: vivi (0): VIDIOC_QUERYBUF
Jul 28 23:20:09 Rincewind kernel: vivi: mmap called, vma=0xffff810068086690
Jul 28 23:20:09 Rincewind kernel: vivi: vma start=0x7f8734c0a000, size=204800, ret=0
Jul 28 23:20:09 Rincewind kernel: vivi (0): VIDIOC_QUERYBUF
Jul 28 23:20:09 Rincewind kernel: vivi: mmap called, vma=0xffff8100680863f0
Jul 28 23:20:09 Rincewind kernel: vivi: vma start=0x7f8734bd8000, size=204800, ret=0
Jul 28 23:20:09 Rincewind kernel: vivi (0): VIDIOC_QBUF
Jul 28 23:20:09 Rincewind kernel: vivi: buffer_prepare, field=4
Jul 28 23:20:09 Rincewind kernel: vivi (0): VIDIOC_QBUF
Jul 28 23:20:09 Rincewind kernel: vivi: buffer_prepare, field=4
Jul 28 23:20:09 Rincewind kernel: vivi (0): VIDIOC_STREAMON
Jul 28 23:20:09 Rincewind kernel: vivi: buffer_queue
Jul 28 23:20:09 Rincewind kernel: vivi: buffer_queue
Jul 28 23:20:09 Rincewind kernel: vivi: buffer_release
Jul 28 23:20:09 Rincewind kernel: vivi: free_buffer, state: 5
Jul 28 23:20:09 Rincewind kernel: vivi: free_buffer: freed
Jul 28 23:20:09 Rincewind kernel: vivi: buffer_release
Jul 28 23:20:09 Rincewind kernel: vivi: free_buffer, state: 5
Jul 28 23:20:09 Rincewind kernel: vivi: free_buffer: freed
Jul 28 23:20:09 Rincewind kernel: vivi: vivi_stop_thread
Jul 28 23:20:09 Rincewind kernel: vivi: thread: exit
Jul 28 23:20:09 Rincewind kernel: vivi: buffer_release
Jul 28 23:20:09 Rincewind kernel: vivi: free_buffer, state: 0
Jul 28 23:20:09 Rincewind kernel: vivi: free_buffer: freed
Jul 28 23:20:09 Rincewind kernel: vivi: buffer_release
Jul 28 23:20:09 Rincewind kernel: vivi: free_buffer, state: 0
Jul 28 23:20:09 Rincewind kernel: vivi: free_buffer: freed
Jul 28 23:20:09 Rincewind kernel: vivi: close called (minor=0, users=0)

Kernel Log for libv4l2 case:
Jul 28 23:21:03 Rincewind kernel: vivi: open called (minor=0)
Jul 28 23:21:03 Rincewind kernel: vivi: open minor=0 type=video-cap users=1
Jul 28 23:21:03 Rincewind kernel: vivi: vivi_start_thread
Jul 28 23:21:03 Rincewind kernel: vivi: returning from vivi_start_thread
Jul 28 23:21:03 Rincewind kernel: vivi (0): VIDIOC_QUERYCAP
Jul 28 23:21:03 Rincewind kernel: vivi (0): VIDIOC_G_FMT
Jul 28 23:21:03 Rincewind kernel: vivi (0): VIDIOC_ENUM_FMT
Jul 28 23:21:03 Rincewind kernel: vivi (0): VIDIOC_ENUM_FMT
Jul 28 23:21:03 Rincewind kernel: vivi (0): VIDIOC_TRY_FMT
Jul 28 23:21:03 Rincewind kernel: vivi (0): VIDIOC_S_FMT
Jul 28 23:21:03 Rincewind kernel: vivi (0): VIDIOC_REQBUFS
Jul 28 23:21:03 Rincewind kernel: vivi: thread started
Jul 28 23:21:03 Rincewind kernel: vivi: buffer_setup, count=2, size=202752
Jul 28 23:21:03 Rincewind kernel: vivi: vivi_sleep dma_q=0xffff81005c480640
Jul 28 23:21:03 Rincewind kernel: vivi: Thread tick
Jul 28 23:21:03 Rincewind kernel: vivi: No active queue to serve
Jul 28 23:21:03 Rincewind kernel: vivi (0): VIDIOC_QUERYBUF
Jul 28 23:21:03 Rincewind kernel: vivi: mmap called, vma=0xffff81007ab7ea80
Jul 28 23:21:03 Rincewind kernel: vivi: vma start=0x7f29aa02f000, size=204800, ret=0
Jul 28 23:21:03 Rincewind kernel: vivi (0): VIDIOC_QUERYBUF
Jul 28 23:21:03 Rincewind kernel: vivi: mmap called, vma=0xffff810070e260a8
Jul 28 23:21:03 Rincewind kernel: vivi: vma start=0x7f29a9ffd000, size=204800, ret=0
Jul 28 23:21:03 Rincewind kernel: vivi (0): VIDIOC_QBUF
Jul 28 23:21:03 Rincewind kernel: vivi: buffer_prepare, field=4
Jul 28 23:21:03 Rincewind kernel: vivi (0): VIDIOC_QBUF
Jul 28 23:21:03 Rincewind kernel: vivi: buffer_prepare, field=4
Jul 28 23:21:03 Rincewind kernel: vivi: vivi_stop_thread
Jul 28 23:21:03 Rincewind kernel: vivi: thread: exit
Jul 28 23:21:03 Rincewind kernel: vivi: buffer_release
Jul 28 23:21:03 Rincewind kernel: vivi: free_buffer, state: 1
Jul 28 23:21:03 Rincewind kernel: vivi: free_buffer: freed
Jul 28 23:21:03 Rincewind kernel: vivi: buffer_release
Jul 28 23:21:03 Rincewind kernel: vivi: free_buffer, state: 1
Jul 28 23:21:03 Rincewind kernel: vivi: free_buffer: freed
Jul 28 23:21:03 Rincewind kernel: vivi: close called (minor=0, users=0)


--7AUc2qLy4jB3hD7Z
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="reqbufs.c"

// gcc -std=gnu99 -ggdb -L /home/gjasny/src/libv4l-0.3.7/libv4l2 -L /home/gjasny/src/libv4l-0.3.7/libv4lconvert -I/home/gjasny/src/libv4l-0.3.7/include -lv4l2 -lv4lconvert -o reqbufs reqbufs.c

#include <errno.h>
#include <fcntl.h>
#include <pthread.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <linux/ioctl.h>
#include <linux/videodev2.h>

#if 1
# include <libv4l2.h>
# define my_ioctl       v4l2_ioctl
# define my_open        v4l2_open
# define my_close       v4l2_close
# define my_mmap        v4l2_mmap
#else
# define my_ioctl       ioctl
# define my_open        open
# define my_close       close
# define my_mmap        mmap
#endif

#define NBUFFERS        2
#define WIDTH           352
#define HEIGHT          288

struct buffer {
    void   *start;
    size_t length;
} g_buffers[NBUFFERS];

static int xioctl( int fd, unsigned long int request, void *arg )
{
    int r;

    do r = my_ioctl (fd, request, arg);
    while (r == -1 && errno == EINTR);

    return r;
}

int main(int argc, char *argv[])
{
    const char *device = "/dev/video0";

    int fd = my_open (device, O_RDWR);
    if (!fd) {
        perror ("open");
        return -1;
    }
    
    struct v4l2_format format;
    memset( &format, 0, sizeof(struct v4l2_format));
    format.type                = V4L2_BUF_TYPE_VIDEO_CAPTURE;
    format.fmt.pix.width       = WIDTH;
    format.fmt.pix.height      = HEIGHT;
    format.fmt.pix.pixelformat = V4L2_PIX_FMT_YUYV;
    format.fmt.pix.field       = V4L2_FIELD_ANY;

    if (xioctl (fd, VIDIOC_S_FMT, &format) == -1) {
        perror("ioctl (VIDIOC_S_FMT)");
        return -1;
    }

    // init mmap
    struct v4l2_requestbuffers m_req;
    memset( &m_req, 0, sizeof(struct v4l2_requestbuffers) );

    m_req.count   = NBUFFERS;
    m_req.type    = V4L2_BUF_TYPE_VIDEO_CAPTURE;
    m_req.memory  = V4L2_MEMORY_MMAP;

    if (xioctl (fd, VIDIOC_REQBUFS, &m_req) == -1) {
        if (EINVAL == errno) {
            fprintf (stderr, "device does not support memory mapping.\n");
        } else {
            perror ("ioctl (VIDIOC_REQBUFS)");
        }
        return -1;
    }

    if (m_req.count < NBUFFERS) {
        fprintf (stderr, "Insufficient buffer memory.\n");
        return -1;
    }

    for (unsigned i = 0; i < m_req.count; ++i) {

        struct v4l2_buffer buf;
        memset( &buf, 0, sizeof(buf) );

        buf.type        = V4L2_BUF_TYPE_VIDEO_CAPTURE;
        buf.memory      = V4L2_MEMORY_MMAP;
        buf.index       = i;

        if (xioctl (fd, VIDIOC_QUERYBUF, &buf) == -1) {
            perror("ioctl (VIDIOC_QUERYBUF)");
            return -1;
        }

        g_buffers[i].length = buf.length;
        g_buffers[i].start  = my_mmap (NULL /* start anywhere */,
                                       buf.length,
                                       PROT_READ | PROT_WRITE /* required */,
                                       MAP_SHARED /* recommended */,
                                       fd, buf.m.offset);

        if (g_buffers[i].start == MAP_FAILED) {
            perror("mmap");
            return -1;
        }
    }

    for (unsigned i = 0; i < NBUFFERS; ++i) {
        struct v4l2_buffer buf;
        memset( &buf, 0, sizeof(buf) );

        buf.type        = V4L2_BUF_TYPE_VIDEO_CAPTURE;
        buf.memory      = V4L2_MEMORY_MMAP;
        buf.index       = i;

        if (xioctl (fd, VIDIOC_QBUF, &buf) == -1) {
            perror ("ioctl (VIDIOC_QBUF)");
            return -1;
        }
    }

    enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
    if (xioctl (fd, VIDIOC_STREAMON, &type) == -1) {
        perror("ioctl (VIDIOC_STREAMON)");
        return -1;
    }

    my_close (fd);

    return -1;
}

--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--7AUc2qLy4jB3hD7Z--
