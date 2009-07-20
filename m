Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web23806.mail.ird.yahoo.com ([87.248.115.79])
	by mail.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <diegicweb@yahoo.es>) id 1MStw6-0001ZF-8h
	for linux-dvb@linuxtv.org; Mon, 20 Jul 2009 16:33:51 +0200
Message-ID: <420792.31511.qm@web23806.mail.ird.yahoo.com>
Date: Mon, 20 Jul 2009 14:33:16 +0000 (GMT)
From: =?iso-8859-1?Q?Diego_P=E9rez_Hern=E1ndez?= <diegicweb@yahoo.es>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] some technical help please!!!
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


Hello linux-dvb friends!

I'm a spanish programmer, working now with Eclipse C/C++ and a tuner card (AVerTV DVB-T Volar).

I'm using the functions described in DVB-API version 3 which I downloaded, and several obstacles are appearing while programming software which manages the mentioned card.

In particular I have problems with the function ioctl, in particular with its cases FE_GET_EVENT and SET_FRONTEND (they return error value, -1, while in other cases like READ_SNR, READ_BER, etc, everything works).

I'm sure that my call to the functions (and the rest of the code) is alright but I never get the event, although the signal in my laboratory is more than enough.

I have tried everything I could imagine and now I'm bogged down.
Have any of you worked in the same conditions? I would be very pleased to receive any help, suggestions, advice, whatever...

Thank you very much!!


      

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
