Return-path: <linux-media-owner@vger.kernel.org>
Received: from pil.idi.ntnu.no ([129.241.107.93]:39362 "EHLO pil.idi.ntnu.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbZCXVWt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2009 17:22:49 -0400
Date: Tue, 24 Mar 2009 21:56:58 +0100
From: Nils Grimsmo <nils.grimsmo@idi.ntnu.no>
To: V4L/DVB <linux-media@vger.kernel.org>
Subject: scan vs dvbscan
Message-ID: <20090324205658.GH4563@stud3115.idi.ntnu.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

both in the Ubuntu package dvb-apps, and in the source from
http://linuxtv.org/hg/dvb-apps , there is both a program scan and dvbscan,
which are not the same.  Which should be used when?  I have a TechnoTrend
C-1501 DVB-C card, and only `scan` worked.  `dvbscan
/usr/local/share/dvb/dvb-c/no-Oslo-CanalDigital` gave the output "Unable
to query frontend status".  

Could the --help in the programs say something about which should work
when?

In util/dvbscan/dvbscan.c main():

  if (dvbfe_get_info(fe, DVBFE_INFO_LOCKSTATUS, &feinfo,
      DVBFE_INFO_QUERYTYPE_IMMEDIATE, 0) !=
      DVBFE_INFO_QUERYTYPE_IMMEDIATE) {
    fprintf(stderr, "Unable to query frontend status\n");
    exit(1);
  }

In lib/libdvbapi/dvbfe.c dvbfe_get_info():

  switch(querytype) {
  case DVBFE_INFO_QUERYTYPE_IMMEDIATE:
    if (querymask & DVBFE_INFO_LOCKSTATUS) {
      if (!ioctl(fehandle->fd, FE_READ_STATUS, &kevent.status)) {
        returnval |= DVBFE_INFO_LOCKSTATUS;
      }
    }       
  ...
  return returnval;

I do not really understand this.  If the call to ioctl *suceeds*,
DVBFE_INFO_LOCKSTATUS is returned, and exit(1) is called in main().  I do
not really understand this.  


Klem fra Nils

-- 
http://www.idi.ntnu.no/~nilsgri/                Why is this thus?
                             What is the reason of this thusness?
                                                  - Artemus Ward
