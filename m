Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.174])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mariofutire@googlemail.com>) id 1JVWzs-00021q-Rs
	for linux-dvb@linuxtv.org; Sat, 01 Mar 2008 20:03:48 +0100
Received: by ug-out-1314.google.com with SMTP id o29so1517349ugd.20
	for <linux-dvb@linuxtv.org>; Sat, 01 Mar 2008 11:03:36 -0800 (PST)
Message-ID: <47C9A880.2020701@googlemail.com>
Date: Sat, 01 Mar 2008 19:03:28 +0000
From: Andrea <mariofutire@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Help with demux, dvr and ringbuffers
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

I've understood a bit more how demux, dvr and rigbuffers work, but I still have a couple of issues.
I've been studying tzap, which seems much easier than gnutv.

tzap opens the demux twice (audio and video) and then opens the dvr to read the multiplexed data.
There are 3 ringbuffers involved:

When a demux is opened, a ringbuffer of 8192 is created (so there are 2 of them).
I can change its size using DMX_SET_BUFFER_SIZE on the demux.

Then when the dvr is opened an other ringbuffer is created of size 1925120 = 18 * 100 * 1024.
I don't know how to change its size.

My question is the following:

When I setup the demux to output to the dvr with DMX_OUT_TS_TAP, what happens afterwards?
Is the following correct or wrong?

1) The "kernel" will write data into the 2 buffers
2) The "kernel" will read from the 2 demuxes and write to the dvr.
This has very low latency so a small ringbuffer for the 2 demuxes is ok.

3) A userspace application has to read from the dvr. If it is not fast enough the dvr's ringbuffer 
gets filled and we are in troubles.
If this happens I think the best solution would be to overwrite the oldest data.

This ringbuffer needs to take into account all sort of bottleneck one might have.




If it is true I have to find how to change the size of the dvr's ringbuffer.
Anybody knows why the callback (in dmxdev.c)

static int dvb_dvr_do_ioctl(struct inode *inode, struct file *file,
			    unsigned int cmd, void *parg)

does not handle DMX_SET_BUFFER_SIZE? Is there an intrinsic issue or is it just to be done?

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
