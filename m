Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:58569 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789AbbBMNml (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2015 08:42:41 -0500
Received: from localhost ([79.231.112.199]) by mail.gmx.com (mrgmx101) with
 ESMTPSA (Nemesis) id 0MGEv5-1YPmUy0WmN-00F8mX for
 <linux-media@vger.kernel.org>; Fri, 13 Feb 2015 14:42:39 +0100
Date: Fri, 13 Feb 2015 14:42:38 +0100
From: Daniel Lord <d_lord@gmx.de>
To: linux-media@vger.kernel.org
Subject: Patch to add a timestamping and version option to femon
Message-ID: <20150213134238.GA17802@gmx.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

as I have been in need for a monitoring tool, to check the (in)stability of my
SAT-DVB setup I came across femon of dvb-apps. As it doesn't has a timestamp
option I haven't been able to correlate the outage of video with a signal
reported by femon easily.

Therefore please find attached a patch which adds a timestamping option (-t)
to femon.

It also adds a version option (-v) as you stated somewhere on your homepage
this would be needed. Be carefull with the compiletime/date line. It will
break the debian reproducable build system.

Kind regards

    Daniel

--RnlQjJ0d97Da+TV1
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="femon.diff"

34d33
< #include <time.h>
42,43d40
< #define TLEN 150
< #define VERSION "0.2"
54,56c51
<     "     -c number : samples to take (default 0 = infinite)\n"
<     "     -v        : display version information\n"
<     "     -t        : add timestamp for monitoring\n\n";
---
>     "     -c number : samples to take (default 0 = infinite)\n\n";
61d55
< char timebuf[TLEN];
69,74d62
< static void version(void)
< {
< 	printf("This is femon version %s\n", VERSION);
< 	printf("compiled at %s %s\n", __DATE__, __TIME__); /* remove for reproduceable builds */
< 	exit(1);
< }
77c65
< int check_frontend (struct dvbfe_handle *fe, int human_readable, unsigned int count, int timestamp)
---
> int check_frontend (struct dvbfe_handle *fe, int human_readable, unsigned int count)
82d69
< 	time_t curtime = time(NULL);
109,114c96
< if (timestamp) {
< 	curtime = time(NULL);
< 	strncpy(timebuf,ctime(&curtime),TLEN);
< 	timebuf[strlen(timebuf) - 1] = 0x00;
< 	printf("%s | ",timebuf);
< }
---
> 
166c148
< int do_mon(unsigned int adapter, unsigned int frontend, int human_readable, unsigned int count, int timestamp)
---
> int do_mon(unsigned int adapter, unsigned int frontend, int human_readable, unsigned int count)
196c178
< 	result = check_frontend (fe, human_readable, count, timestamp);
---
> 	result = check_frontend (fe, human_readable, count);
208d189
< 	int timestamp = 0;
210c191
< 	   while ((opt = getopt(argc, argv, "vrAHta:f:c:")) != -1) {
---
>        while ((opt = getopt(argc, argv, "rAHa:f:c:")) != -1) {
216,218d196
< 		case 'v':
< 			version();
< 			break;
240,242d217
< 		case 't':
< 			timestamp=1;
< 			break;
246c221
< 	do_mon(adapter, frontend, human_readable, count, timestamp);
---
> 	do_mon(adapter, frontend, human_readable, count);

--RnlQjJ0d97Da+TV1--
