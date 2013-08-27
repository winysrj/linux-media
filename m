Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52594 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571Ab3H0OED (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Aug 2013 10:04:03 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1VEJsF-0004ry-2q
	for linux-media@vger.kernel.org; Tue, 27 Aug 2013 16:03:59 +0200
Received: from exchange.muehlbauer.de ([194.25.158.132])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 27 Aug 2013 16:03:59 +0200
Received: from Bassai_Dai by exchange.muehlbauer.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 27 Aug 2013 16:03:59 +0200
To: linux-media@vger.kernel.org
From: Tom <Bassai_Dai@gmx.net>
Subject: OMAP3 ISP DQBUF hangs using yavta and media-ctl tool
Date: Tue, 27 Aug 2013 14:03:40 +0000 (UTC)
Message-ID: <loom.20130827T155601-277@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I try to get an image with my ov3640 camera sensor and I configured the
pipeline as follows:

root@overo2:~/media_test/bin# sudo ./media-ctl -v -r -l '"ov3640
3-003c":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC
output":0[1]'
Opening media device /dev/media0
Enumerating entities
Found 16 entities
Enumerating pads and links
Resetting all links to inactive
Setting up link 16:0 -> 5:0 [1]
Setting up link 5:1 -> 6:0 [1]
root@overo2:~/media_test/bin# sudo ./media-ctl -v -V '"ov3640 3-003c":0
[SBGGR10 640x480 (32,20)/640x480], "OMAP3 ISP CCDC":1 [SBGGR10 640x480]'
Opening media device /dev/media0
Enumerating entities
Found 16 entities
Enumerating pads and links
Setting up selection target 0 rectangle (32,20)/640x480 on pad ov3640 3-003c/0
Selection rectangle set: (32,20)/640x480
Setting up format SBGGR10 640x480 on pad ov3640 3-003c/0
Format set: SBGGR10 640x480
Setting up format SBGGR10 640x480 on pad OMAP3 ISP CCDC/0
Format set: SBGGR10 640x480
Setting up format SBGGR10 640x480 on pad OMAP3 ISP CCDC/1
Format set: SBGGR10 640x480


Then I wanted to take an image with yavta, but it hangs on DQBUF:

root@overo2:~/media_test/bin# cd
root@overo2:~# cd yavta-HEAD-d9b7cfc/
root@overo2:~/yavta-HEAD-d9b7cfc# sudo strace ./yavta -n 1 -f SBGGR10 -s
640x480 --capture=1 --file=/home/root/image  /dev/video2
execve("./yavta", ["./yavta", "-n", "1", "-f", "SBGGR10", "-s", "640x480",
"--capture=1", "--file=/home/root/image", "/dev/video2"], [/* 13 vars */]) = 0
brk(0)                                  = 0x413000
uname({sys="Linux", node="overo2", ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
0xb6f27000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/var/run/ld.so.cache", O_RDONLY)  = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=63134, ...}) = 0
mmap2(NULL, 63134, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb6ef4000
close(3)                                = 0
open("/lib/librt.so.1", O_RDONLY)       = 3
read(3,
"\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0\240\26\0\0004\0\0\0"...,
512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=26572, ...}) = 0
mmap2(NULL, 57876, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =
0xb6ee5000
mprotect(0xb6eeb000, 28672, PROT_NONE)  = 0
mmap2(0xb6ef2000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x5) = 0xb6ef2000
close(3)                                = 0
open("/lib/libc.so.6", O_RDONLY)        = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0\fR\1\0004\0\0\0"...,
512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=1168720, ...}) = 0
mmap2(NULL, 1204784, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =
0xb6dbe000
mprotect(0xb6ed7000, 32768, PROT_NONE)  = 0
mmap2(0xb6edf000, 12288, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x119) = 0xb6edf000
mmap2(0xb6ee2000, 8752, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb6ee2000
close(3)                                = 0
open("/lib/libpthread.so.0", O_RDONLY)  = 3
read(3,
"\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0\300B\0\0004\0\0\0"..., 512)
= 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=84340, ...}) = 0
mmap2(NULL, 123396, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =
0xb6d9f000
mprotect(0xb6db3000, 28672, PROT_NONE)  = 0
mmap2(0xb6dba000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x13) = 0xb6dba000
mmap2(0xb6dbc000, 4612, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb6dbc000
close(3)                                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
0xb6f26000
set_tls(0xb6f26820, 0xb6f26820, 0x684, 0xb6f26ef8, 0xb6f29050) = 0
mprotect(0xb6dba000, 4096, PROT_READ)   = 0
mprotect(0xb6edf000, 8192, PROT_READ)   = 0
mprotect(0xb6ef2000, 4096, PROT_READ)   = 0
mprotect(0xb6f28000, 4096, PROT_READ)   = 0
munmap(0xb6ef4000, 63134)               = 0
set_tid_address(0xb6f263c8)             = 1381
set_robust_list(0xb6f263d0, 0xc)        = 0
futex(0xbee03cd4, FUTEX_WAKE_PRIVATE, 1) = 0
rt_sigaction(SIGRTMIN, {0xb6da31c8, [], SA_SIGINFO|0x4000000}, NULL, 8) = 0
rt_sigaction(SIGRT_1, {0xb6da2d44, [], SA_RESTART|SA_SIGINFO|0x4000000},
NULL, 8) = 0
rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) = 0
getrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, rlim_max=RLIM_INFINITY}) = 0
open("/dev/video2", O_RDWR)             = 3
fstat64(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 0), ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
0xb6f25000
write(1, "Device /dev/video2 opened.\n", 27Device /dev/video2 opened.
) = 27
ioctl(3, VIDIOC_QUERYCAP or VT_OPENQRY, 0xbee039c0) = 0
write(1, "Device `OMAP3 ISP CCDC output' o"..., 69Device `OMAP3 ISP CCDC
output' on `media' is a video capture device.
) = 69
ioctl(3, VIDIOC_S_FMT or VT_RELDISP, 0xbee03868) = 0
write(1, "Video format set: SBGGR10 (30314"..., 78Video format set: SBGGR10
(30314742) 640x480 (stride 1280) buffer size 614400
) = 78
ioctl(3, VIDIOC_G_FMT or VT_SENDSIG, 0xbee0379c) = 0
write(1, "Video format: SBGGR10 (30314742)"..., 74Video format: SBGGR10
(30314742) 640x480 (stride 1280) buffer size 614400
) = 74
ioctl(3, VIDIOC_REQBUFS or VT_DISALLOCATE, 0xbee03b88) = 0
write(1, "1 buffers requested.\n", 211 buffers requested.
)  = 21
brk(0)                                  = 0x413000
brk(0x434000)                           = 0x434000
ioctl(3, VIDIOC_QUERYBUF or VT_RESIZE, 0xbee03a78) = 0
write(1, "length: 614400 offset: 0 timesta"..., 49length: 614400 offset: 0
timestamp type: unknown
) = 49
mmap2(NULL, 614400, PROT_READ|PROT_WRITE, MAP_SHARED, 3, 0) = 0xb6d09000
write(1, "Buffer 0 mapped at address 0xb6d"..., 39Buffer 0 mapped at address
0xb6d09000.
) = 39
ioctl(3, VIDIOC_QBUF or VT_SETACTIVATE, 0xbee035dc) = 0
ioctl(3, VIDIOC_STREAMON, 0xbee0354c)   = 0
clock_gettime(CLOCK_MONOTONIC, {2658, 373383271}) = 0
ioctl(3, VIDIOC_DQBUF


By printing out what the kernel does I figured out that ccdc stays in a
waiting function "isp_video_buffer_wait". It seems like there has to be an
interupt to come up, but it doesn't.

[ 2657.334289] TOM void ccdc_vd1_isr ##########
[ 2657.358917] TOM void ccdc_vd0_isr ##########
[ 2657.363403] TOM ccdc_isr_buffer ##########
[ 2657.367645] TOM ccdc_isr_buffer 1 ##########
[ 2657.372100] TOM ccdc_isr_buffer 2 ##########
[ 2657.376556] TOM ccdc_isr_buffer 3 ##########
[ 2657.383514] TOM ccdc_isr_buffer ERROR 3 ##########
[ 2657.388519] omap3isp omap3isp: CCDC won't become idle!
[ 2657.393859] TOM void ccdc_vd0_isr DONE ##########
[ 2658.299743] TOM isp_video_streamon 8 ##########
[ 2658.304504] TOM isp_video_streamon DONE ##########
[ 2658.314025] TOM isp_video_dqbuf ##########
[ 2658.319427] TOM omap3isp_video_queue_dqbuf ##########
[ 2658.325439] TOM omap3isp_video_queue_dqbuf temp 1 ##########
[ 2658.332153] TOM omap3isp_video_queue_dqbuf temp 1,5 ##########
[ 2658.338897] TOM isp_video_buffer_wait ##########
[ 2658.343719] TOM isp_video_buffer_wait temp ##########


Can anyone help me with this problem?

Best Regards, Tom


the "ispqueue.c":

int omap3isp_video_queue_dqbuf(struct isp_video_queue *queue,
			       struct v4l2_buffer *vbuf, int nonblocking)
{
	printk("TOM omap3isp_video_queue_dqbuf ##########\n");
	struct isp_video_buffer *buf;
	int ret;

	if (vbuf->type != queue->type)
	{
		printk("TOM omap3isp_video_queue_dqbuf ERROR 1 ##########\n");
		return -EINVAL;
	}
	mutex_lock(&queue->lock);

	if (list_empty(&queue->queue)) {
		ret = -EINVAL;
		printk("TOM omap3isp_video_queue_dqbuf ERROR 2 ##########\n");
		goto done;
	}

	printk("TOM omap3isp_video_queue_dqbuf temp 1 ##########\n");

	buf = list_first_entry(&queue->queue, struct isp_video_buffer, stream);
	printk("TOM omap3isp_video_queue_dqbuf temp 1,5 ##########\n");
	if(buf == NULL)
	{
		printk("TOM omap3isp_video_queue_dqbuf temp 1,5 ERROR ##########\n");
	}
	ret = isp_video_buffer_wait(buf, nonblocking);
	if (ret < 0)
	{
		printk("TOM omap3isp_video_queue_dqbuf ERROR 1 ##########\n");
		goto done;
	}

	printk("TOM omap3isp_video_queue_dqbuf temp 2 ##########\n");

	list_del(&buf->stream);

	printk("TOM omap3isp_video_queue_dqbuf temp 3 ##########\n");

	isp_video_buffer_query(buf, vbuf);
	buf->state = ISP_BUF_STATE_IDLE;
	vbuf->flags &= ~V4L2_BUF_FLAG_QUEUED;

	printk("TOM omap3isp_video_queue_dqbuf DONE ##########\n");

done:
	mutex_unlock(&queue->lock);
	return ret;
}

static int isp_video_buffer_wait(struct isp_video_buffer *buf, int nonblocking)
{
	printk("TOM isp_video_buffer_wait ##########\n");
	if (nonblocking) {
		return (buf->state != ISP_BUF_STATE_QUEUED &&
			buf->state != ISP_BUF_STATE_ACTIVE)
			? 0 : -EAGAIN;
	}
	printk("TOM isp_video_buffer_wait temp ##########\n");
	return wait_event_interruptible(buf->wait,
		buf->state != ISP_BUF_STATE_QUEUED &&
		buf->state != ISP_BUF_STATE_ACTIVE);
}

