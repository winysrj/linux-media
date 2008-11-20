Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [85.17.51.120] (helo=master.jcz.nl)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jaap@jcz.nl>) id 1L38Mi-0003d7-Q2
	for linux-dvb@linuxtv.org; Thu, 20 Nov 2008 13:10:36 +0100
Message-ID: <492553AF.4080209@jcz.nl>
Date: Thu, 20 Nov 2008 13:10:23 +0100
From: Jaap Crezee <jaap@jcz.nl>
MIME-Version: 1.0
To: "Michael J. Curtis" <michael.curtis@glcweb.co.uk>
References: <3C276393607085468A28782D978BA5EEECB30B5F24@w2k8svr1.glcdomain8.local>
In-Reply-To: <3C276393607085468A28782D978BA5EEECB30B5F24@w2k8svr1.glcdomain8.local>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Status of TT 3200 S2 card and Mythtv
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

Michael J. Curtis wrote:
> Many thanks to all those who contribute to this list ...........but as a keen linux user I need help in understanding where we are at in respect of a working HD system with the TT3200 S2 card and then, is Mythtv working with the required drivers?

Hi Michael,

I have got a working setup with a budget TT3200 S2 (including CI/CAM module and paytv subscription) and mythtv using
drivers at http://linuxtv.org/hg/v4l-dvb/ and mythtv current trunk svn with patch http://svn.mythtv.org/trac/ticket/5882 .

Currently, i am at patch-patch level http://svn.mythtv.org/trac/attachment/ticket/5882/t5882_S2Api_3.diff
Maybe I will try ...S2Api_5.diff , but I think it will work.


Regards,

Jaap Crezee

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
