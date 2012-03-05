Return-path: <linux-media-owner@vger.kernel.org>
Received: from ccsrelay02.in2p3.fr ([134.158.66.52]:42985 "EHLO
	ccsrelay02.in2p3.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756582Ab2CEWPU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Mar 2012 17:15:20 -0500
Message-ID: <4F5532D0.4030108@free.fr>
Date: Mon, 05 Mar 2012 22:40:32 +0100
From: Skippy <lecotegougdelaforce@free.fr>
Reply-To: lecotegougdelaforce@free.fr
MIME-Version: 1.0
To: Jonathan Nieder <jrnieder@gmail.com>
CC: Jean-Francois Moine <moinejf@free.fr>, linux-media@vger.kernel.org,
	linux-usb@vger.kernel.org
Subject: Re: [bug?] ov519 fails to handle Hercules Deluxe webcam
References: <20120304223239.22117.54556.reportbug@deepthought> <20120305003801.GB27427@burratino> <20120305102101.652b46e7@tele> <20120305093430.GA14386@burratino>
In-Reply-To: <20120305093430.GA14386@burratino>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le 05/03/2012 10:34, Jonathan Nieder a écrit :
> 	make localmodconfig; # optional: minimize configuration
> 	make; # optionally with -j<num>  for parallel build

The compilation failed (see at the end of this email) and I didn't feel 
like trying to debug it so I went for Jean-François' build, and it seems 
to work fine (thanks !).

<HS>Jean-François, please have a look at 
http://fr.wikipedia.org/wiki/Casse_%28typographie%29 or 
http://www.cnrtl.fr/definition/casse (CASSE³) and you may switch back to 
French… ;-)</HS>

-----------------------------------------------------------------------
# LANG=en_US.utf8 make localmodconfig
   HOSTCC  scripts/basic/fixdep
In file included from /usr/include/sys/socket.h:40,
                  from /usr/include/netinet/in.h:25,
                  from /usr/include/arpa/inet.h:23,
                  from scripts/basic/fixdep.c:116:
/usr/include/bits/socket.h:370:24: error: asm/socket.h: No such file or 
directory
make[1]: *** [scripts/basic/fixdep] Error 1
make: *** [scripts_basic] Error 2

# LANG=en_US.utf8 make
   HOSTCC  scripts/basic/fixdep
In file included from /usr/include/sys/socket.h:40,
                  from /usr/include/netinet/in.h:25,
                  from /usr/include/arpa/inet.h:23,
                  from scripts/basic/fixdep.c:116:
/usr/include/bits/socket.h:370:24: error: asm/socket.h: No such file or 
directory
make[2]: *** [scripts/basic/fixdep] Error 1
make[1]: *** [scripts_basic] Error 2
make: *** No rule to make target `include/config/auto.conf', needed by 
`include/config/kernel.release'.  Stop.
-----------------------------------------------------------------------



