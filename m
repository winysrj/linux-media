Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail01.syd.optusnet.com.au ([211.29.132.182])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <darrinritter@optusnet.com.au>) id 1JjpqW-00064v-L4
	for linux-dvb@linuxtv.org; Thu, 10 Apr 2008 08:01:22 +0200
Message-ID: <47FDAD31.6030901@optusnet.com.au>
Date: Thu, 10 Apr 2008 15:31:21 +0930
From: Darrin Ritter <darrinritter@optusnet.com.au>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Conexant CX23880 suspected driver memory leak
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

Hi All,

Whilst helping in the development of me-tv:

http://launchpad.net/me-tv/

it was discovered that there was a memory leak that uses up memory at an 
approximate rate of 1Mb per 5min.

This cam be duplicated by simply using the me-tv (or klear) application 
and in my case the winfast DVT2000H card and using the gnome system 
monitor, the memory usage rises steadily and linearly.

It became apparent that the problem was driver based as some people were 
using different devices and weren't experiencing the same problems.



The kernel details are as follows:
    dv@StudioMachine:~/.me-tv$ uname -r
    2.6.22-14-generic
    running Ubuntu 7.10



The device details are:
    root@StudioMachine:/home/dv# lspci |grep CX
    00:0b.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI 
Video and Audio Decoder (rev 05)
    00:0b.1 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and 
Audio Decoder [Audio Port] (rev 05)
    00:0b.2 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and 
Audio Decoder [MPEG Port] (rev 05)



The following are excerpts from the discussion with the me-tv 
development team:


    It was initially thought that the problem started with version 
0.5.25 so I did some testing this morning on channel 10 (Standard 
Definition without EPG started) and found the following:

    I recompiled v 0.5.23 and v 0.5.24 and tested them by watching the 
gnome system monitor, at no time did the Memory usage go down during the 
test.

   0.5.23
      Time   Memory usage

      11:05    26.5MB
      11.20    28.9MB
      11:30    31.3MB

   0.5.24
      10:05    25.8MB
      10:20    30.6MB


    Now the interesting thing is I also tested Klear 0.6 (distro 
provided binaries) and got the following results:

  klear v0.6
      11:50    24.0MB
      12:20    29.0MB
      12:35    31.4MB

    To me this proves to problem lies elsewhere either in the Xine code 
or my suspicion is in the driver code, This would explain why it isn't 
showing in up on some people's systems

The following test isolates the fault from the me-tv application and any 
code above the drivers:

    If you put a recorded file at ~/.me-tv/test.ts and change your
    frontend device to some path (in me-tv.config) to a path that does not
    exist then Me TV will fail to open the device and then try to play
    ~/.me-tv/test.ts.  This will completely bypass the DVB device and you
    should be able to determine if the driver is at fault.

I tested the application for an hour and the memory usage stayed at a 
steady 14.6 Mb, given the previous tests I would have expected the 
memory usage to rise to approx 26.6 Mb

thanks Darrin Ritter


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
