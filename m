Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from crow.cadsoft.de ([217.86.189.86] helo=raven.cadsoft.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Klaus.Schmidinger@cadsoft.de>) id 1LeBbg-0003gD-NY
	for linux-dvb@linuxtv.org; Mon, 02 Mar 2009 18:07:09 +0100
Received: from [192.168.100.10] (hawk.cadsoft.de [192.168.100.10])
	by raven.cadsoft.de (8.14.3/8.14.3) with ESMTP id n22H74Gg020776
	for <linux-dvb@linuxtv.org>; Mon, 2 Mar 2009 18:07:04 +0100
Message-ID: <49AC1237.9000104@cadsoft.de>
Date: Mon, 02 Mar 2009 18:07:03 +0100
From: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Bug in DVB header files
Reply-To: linux-media@vger.kernel.org
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

Reinhard Nissl made me aware of the fact that with recent versions
of the driver from http://linuxtv.org/hg/v4l-dvb there is apparently
someting wrong with the header files. Doing

#include <linux/videodev2.h>
#include <linux/dvb/audio.h>

results in

.../linux/dvb/audio.h:79: error: 'uint16_t' does not name a type

Doing the #includes in reverse order gives

/usr/include/sys/select.h:78: error: conflicting declaration 'typedef struct fd_set fd_set'
/usr/include/linux/types.h:12: error: 'fd_set' has a previous declaration as 'typedef struct __kernel_fd_set fd_set'


The only way to compile VDR with the recent driver is to revert to
the header files as they were before the change labeled

"backport include changes on some .h files"

Klaus

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
