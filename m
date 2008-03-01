Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mariofutire@googlemail.com>) id 1JVFSX-00013D-QF
	for linux-dvb@linuxtv.org; Sat, 01 Mar 2008 01:20:14 +0100
Received: by nf-out-0910.google.com with SMTP id d21so2788609nfb.11
	for <linux-dvb@linuxtv.org>; Fri, 29 Feb 2008 16:20:09 -0800 (PST)
Message-ID: <47C8A135.9070209@googlemail.com>
Date: Sat, 01 Mar 2008 00:20:05 +0000
From: Andrea <mariofutire@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Help using DMX_SET_BUFFER_SIZE
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

I've tried to add an extra argument to gnutv to set the size of the dvb_ringbuffer via 
DMX_SET_BUFFER_SIZE.

I have not really understood the difference between dvr and demux.
It seems that gnutv uses the dvr to read from the DVB card and then copies the content to a file.

I call

int dvbdemux_set_buffer(int fd, int bufsize)
{
	return ioctl(fd, DMX_SET_BUFFER_SIZE, bufsize);
}

on the dvr (I think), but it does not make much of a change. The ioctl call returns success.
I've printed a lot of debug output (adding a few dprintk) and this is what I see when I run gnutv.
Now, I set the buffer to 1024 * 1024 which is nowhere in the log.
I cannot see in the log the 2 functions (demux and dvr) handling this ioctl call:
dvb_demux_do_ioctl and dvb_dvr_do_ioctl (I've added some printk as well).

	printk("function : %s %d\n", __FUNCTION__, cmd);


/sbin/modprobe dvb_core debug=1 dvbdev_debug=1


Feb 29 23:59:34 thinkpad kernel: function : dvb_demux_open
Feb 29 23:59:34 thinkpad kernel: dmxdev: dvb_ringbuffer_init 8192
Feb 29 23:59:34 thinkpad kernel: function : dvb_dmxdev_filter_set
Feb 29 23:59:34 thinkpad kernel: function : dvb_dvr_open
Feb 29 23:59:34 thinkpad kernel: function : dvb_demux_open
Feb 29 23:59:34 thinkpad kernel: dmxdev: dvb_ringbuffer_init 8192
Feb 29 23:59:34 thinkpad kernel: function : dvb_dmxdev_filter_set
Feb 29 23:59:34 thinkpad kernel: dmxdev: dvb_ringbuffer_init 1925120
Feb 29 23:59:34 thinkpad kernel: function : dvb_demux_open
Feb 29 23:59:34 thinkpad kernel: dmxdev: dvb_ringbuffer_init 8192
Feb 29 23:59:35 thinkpad kernel: dmxdev: section callback 00 b0 25 10 04 c5
Feb 29 23:59:35 thinkpad kernel: function : dvb_demux_open
Feb 29 23:59:35 thinkpad kernel: dmxdev: dvb_ringbuffer_init 8192
Feb 29 23:59:35 thinkpad kernel: function : dvb_dmxdev_filter_set
Feb 29 23:59:35 thinkpad kernel: function : dvb_demux_open
Feb 29 23:59:35 thinkpad kernel: dmxdev: dvb_ringbuffer_init 8192
Feb 29 23:59:35 thinkpad kernel: dmxdev: section callback 02 b0 82 10 84 c7
Feb 29 23:59:35 thinkpad kernel: function : dvb_demux_open
Feb 29 23:59:35 thinkpad kernel: dmxdev: dvb_ringbuffer_init 8192
Feb 29 23:59:35 thinkpad kernel: function : dvb_demux_open
Feb 29 23:59:35 thinkpad kernel: dmxdev: dvb_ringbuffer_init 8192
Feb 29 23:59:35 thinkpad kernel: function : dvb_demux_open
Feb 29 23:59:35 thinkpad kernel: dmxdev: dvb_ringbuffer_init 8192
Feb 29 23:59:35 thinkpad kernel: function : dvb_demux_open
Feb 29 23:59:35 thinkpad kernel: dmxdev: dvb_ringbuffer_init 8192
Feb 29 23:59:35 thinkpad kernel: function : dvb_demux_open
Feb 29 23:59:35 thinkpad kernel: dmxdev: dvb_ringbuffer_init 8192
Feb 29 23:59:35 thinkpad kernel: function : dvb_demux_open
Feb 29 23:59:35 thinkpad kernel: dmxdev: dvb_ringbuffer_init 8192
Feb 29 23:59:35 thinkpad kernel: function : dvb_demux_open
Feb 29 23:59:35 thinkpad kernel: dmxdev: dvb_ringbuffer_init 8192
Feb 29 23:59:35 thinkpad kernel: function : dvb_demux_open
Feb 29 23:59:35 thinkpad kernel: dmxdev: dvb_ringbuffer_init 8192
Feb 29 23:59:35 thinkpad kernel: function : dvb_demux_open
Feb 29 23:59:35 thinkpad kernel: dmxdev: dvb_ringbuffer_init 8192
Feb 29 23:59:35 thinkpad kernel: function : dvb_demux_open
Feb 29 23:59:35 thinkpad kernel: dmxdev: dvb_ringbuffer_init 8192
Feb 29 23:59:35 thinkpad kernel: dmxdev: section callback 00 b0 25 10 04 c5
Feb 29 23:59:35 thinkpad kernel: dmxdev: section callback 02 b0 82 10 84 c7
Feb 29 23:59:35 thinkpad kernel: dmxdev: section callback 00 b0 25 10 04 c5
Feb 29 23:59:35 thinkpad kernel: dmxdev: section callback 02 b0 82 10 84 c7
Feb 29 23:59:35 thinkpad kernel: dmxdev: section callback 00 b0 25 10 04 c5
Feb 29 23:59:35 thinkpad kernel: dmxdev: section callback 02 b0 82 10 84 c7
Feb 29 23:59:36 thinkpad kernel: dmxdev: section callback 70 70 05 d4 fd 23
Feb 29 23:59:36 thinkpad kernel: dmxdev: section callback 00 b0 25 10 04 c5
Feb 29 23:59:36 thinkpad kernel: dmxdev: section callback 02 b0 82 10 84 c7
Feb 29 23:59:36 thinkpad kernel: dmxdev: section callback 00 b0 25 10 04 c5
Feb 29 23:59:36 thinkpad kernel: dmxdev: section callback 02 b0 82 10 84 c7



My questions are

1) how many ringbuffers are there? 2 sizes are reported in the log.
2) in the log it seems the buffer is recreated every time.
3) why can't I see any call to dvb_demux_do_ioctl and dvb_dvr_do_ioctl?
4) ... what is the difference between demux and dvr? :-)

I'm using a Hauppauge WinTV NOVA T USB2, 2.6.24.2, letest mercurial source code.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
