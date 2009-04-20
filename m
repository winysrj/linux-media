Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52087 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894AbZDTPso (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 11:48:44 -0400
Date: Mon, 20 Apr 2009 12:48:39 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Uri Shkolnik <urishk@yahoo.com>
Cc: LinuxML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [0904_8] Siano: add messages handling for big-endian
 target
Message-ID: <20090420124839.72121ed1@pedra.chehab.org>
In-Reply-To: <204559.6386.qm@web110811.mail.gq1.yahoo.com>
References: <204559.6386.qm@web110811.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 5 Apr 2009 01:59:50 -0700 (PDT)
Uri Shkolnik <urishk@yahoo.com> wrote:

> 
> Add code that modify the content of Siano's protocol
> messages when running with big-endian target.

Maybe due to one of the other patches that weren't applied, but this one didn't compile: 

/home/v4l/master/v4l/smsdvb.c:49: error: field 'sms_stat_dvb' has incomplete type
/home/v4l/master/v4l/smsdvb.c: In function 'smsdvb_onresponse':
/home/v4l/master/v4l/smsdvb.c:95: error: invalid application of 'sizeof' to incomplete type 'struct TRANSMISSION_STATISTICS_S' 
/home/v4l/master/v4l/smsdvb.c:95: error: invalid application of 'sizeof' to incomplete type 'struct TRANSMISSION_STATISTICS_S' 
/home/v4l/master/v4l/smsdvb.c:101: error: implicit declaration of function 'CORRECT_STAT_BANDWIDTH'
/home/v4l/master/v4l/smsdvb.c:102: error: implicit declaration of function 'CORRECT_STAT_TRANSMISSON_MODE'
/home/v4l/master/v4l/smsdvb.c:109: error: storage size of 'SignalStatusData' isn't known
/home/v4l/master/v4l/smsdvb.c:125: error: dereferencing pointer to incomplete type
/home/v4l/master/v4l/smsdvb.c:126: error: dereferencing pointer to incomplete type
/home/v4l/master/v4l/smsdvb.c:127: error: dereferencing pointer to incomplete type
/home/v4l/master/v4l/smsdvb.c:128: error: dereferencing pointer to incomplete type
/home/v4l/master/v4l/smsdvb.c:129: error: dereferencing pointer to incomplete type
/home/v4l/master/v4l/smsdvb.c:130: error: dereferencing pointer to incomplete type
/home/v4l/master/v4l/smsdvb.c:131: error: implicit declaration of function 'CORRECT_STAT_RSSI'
/home/v4l/master/v4l/smsdvb.c:133: error: dereferencing pointer to incomplete type
/home/v4l/master/v4l/smsdvb.c:134: error: dereferencing pointer to incomplete type
/home/v4l/master/v4l/smsdvb.c:135: error: dereferencing pointer to incomplete type
/home/v4l/master/v4l/smsdvb.c:136: error: dereferencing pointer to incomplete type
/home/v4l/master/v4l/smsdvb.c:141: error: dereferencing pointer to incomplete type
/home/v4l/master/v4l/smsdvb.c:145: error: dereferencing pointer to incomplete type
/home/v4l/master/v4l/smsdvb.c:148: error: dereferencing pointer to incomplete type
/home/v4l/master/v4l/smsdvb.c:149: error: dereferencing pointer to incomplete type
/home/v4l/master/v4l/smsdvb.c:151: error: dereferencing pointer to incomplete type
/home/v4l/master/v4l/smsdvb.c:152: error: dereferencing pointer to incomplete type
/home/v4l/master/v4l/smsdvb.c:153: error: dereferencing pointer to incomplete type
/home/v4l/master/v4l/smsdvb.c:109: warning: unused variable 'SignalStatusData'
make[3]: *** [/home/v4l/master/v4l/smsdvb.o] Error 1


Cheers,
Mauro
