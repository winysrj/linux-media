Return-path: <linux-media-owner@vger.kernel.org>
Received: from csldevices.co.uk ([77.75.105.137]:44335 "EHLO
	mhall.vps.goscomb.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753232AbZJELNf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Oct 2009 07:13:35 -0400
Received: from [212.49.228.51] (helo=[192.168.17.1])
	by mhall.vps.goscomb.net with esmtp (Exim 4.63)
	(envelope-from <phil@csldevices.co.uk>)
	id 1MuktW-0002wO-UC
	for linux-media@vger.kernel.org; Mon, 05 Oct 2009 11:34:19 +0100
Message-ID: <4AC9CBA5.5050308@csldevices.co.uk>
Date: Mon, 05 Oct 2009 11:34:13 +0100
From: phil <phil@csldevices.co.uk>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: writing to dvr0 for playback
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm currently trying to replay a transport stream from a file, having 
read through the v3 API docs and this mailing list I'm fairly certain I 
have a good understanding of how to do this. I am however using the 
test_dvr_play test program from the dvb-apps suite rather than writing 
my own code, I have the latest version of dvb-apps from hg as of today.

The dvb hardware which I'm using is a Hauppauge Nova-T usb stick version
3, so thats the DIB7070p tuner and I'm using it with the 2.6.31 kernel
from kernel.org. I've got that working perfectly fine, I can watch tv,
stream to disk and stream a multiplex to disk without issue. The problem
is that if I try to open dvr0 for writing then I get an Error 22
(Invalid Argument). I've looked through the list archives and I've found
similar issues before with no resolution, with this
http://www.linuxtv.org/pipermail/linux-dvb/2008-June/026661.html being
the most recent and most comprehensive I think. This error happens if I
try to cat a ts file into dvr0 or if I run test_dvr_play as follows:

# DVR=/dev/dvb/adapter0/dvr0  DEMUX=/dev/dvb/adapter0/demux0 \
./test_dvr_play /srv/nfs/dave.ts 0x191 0x192
Playing '/srv/nfs/dave.ts', video PID 0x0191, audio PID 0x0192
Failed to open '/dev/dvb/adapter0/dvr0': 22 Invalid argument

I've looked into the test_dvr_play source and it is trying to open dvr0
for writing:

if ((dvrfd = open(dvrdev, O_WRONLY)) == -1) {


Now I've looked into the driver code and this appears to be an issue in
drivers/media/dvb/dvb-core/dmxdev.c specfically in the dvb_dvr_open
routine, from following the code through I've determined that it's
failing because it can't get a frontend (ie dvbdemux->frontend_list is
empty)  when it calls get_fe (line 169 of dmxdev.c) in the following
section of code


  if ((file->f_flags & O_ACCMODE) == O_WRONLY) {
      dmxdev->dvr_orig_fe = dmxdev->demux->frontend;

      if (!dmxdev->demux->write) {
          mutex_unlock(&dmxdev->mutex);
          return -EOPNOTSUPP;
      }

      front = get_fe(dmxdev->demux, DMX_MEMORY_FE);

      if (!front) {
          mutex_unlock(&dmxdev->mutex);
          return -EINVAL;
      }
      dmxdev->demux->disconnect_frontend(dmxdev->demux);
      dmxdev->demux->connect_frontend(dmxdev->demux, front);
  }


I'm now wondering if anyone could shed some light on why it's failing
here and specifically why if I'm trying to avoid using the frontend by
writing in my own TS, it would fail on account of not being able to get
a frontend. Should test_dvr_play be setting up a frontend first before
attempting to open dvr0?


Thanks,

Phil


