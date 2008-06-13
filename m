Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from thouse03.taonet.it ([195.32.96.103])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <steven.dorigotti@tvblob.com>) id 1K7BLH-0003xh-1p
	for linux-dvb@linuxtv.org; Fri, 13 Jun 2008 17:37:45 +0200
Message-Id: <873CB0CE-12F6-4967-9E2A-697CFBAD425F@tvblob.com>
From: Steven Dorigotti <steven.dorigotti@tvblob.com>
To: linux-dvb@linuxtv.org
Mime-Version: 1.0 (Apple Message framework v924)
Date: Fri, 13 Jun 2008 17:36:26 +0200
Subject: [linux-dvb] opening dvr for writing
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

Hello,

   I am trying to write data to the dvr device in order to playback  
recorded streams back on the frontend device for testing purposes.

   I have tried the following test taken from linuxtv-dvb- 
apps-1.1.1.tar.gz (as well as others):

# ./test_dvr_play ../james.mpg 33 34
Playing '../james.mpg', video PID 0x0021, audio PID 0x0022
Failed to open '/dev/dvb/adapter0/dvr0': 22 Invalid argument

both on mips (custom) and x86 (Ubuntu Etch) architectures with the  
following hardware: DiB0070 and wt220u.

   If the open() mode is changed to RDWR instead of WRONLY, errno  
changes to "Operation not supported".

   Is this a known bug and is there a patch available? I have done  
similar tests with a much older version of linux-dvb in the past with  
no problems.

cheers,
Steven


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
