Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.233])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1Jtt0L-0007Wc-7H
	for linux-dvb@linuxtv.org; Thu, 08 May 2008 01:24:57 +0200
Received: by rv-out-0506.google.com with SMTP id b25so705900rvf.41
	for <linux-dvb@linuxtv.org>; Wed, 07 May 2008 16:24:47 -0700 (PDT)
Message-ID: <d9def9db0805071624j62836409jb7a24a3153c1df9e@mail.gmail.com>
Date: Thu, 8 May 2008 01:24:46 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: Rod <Rod@rods.id.au>
In-Reply-To: <48222EA3.8030907@Rods.id.au>
MIME-Version: 1.0
Content-Disposition: inline
References: <48222EA3.8030907@Rods.id.au>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [Fwd: Change wording of DIFF file please]
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

Hey,

On 5/8/08, Rod <Rod@rods.id.au> wrote:
>     Repost as I think I fell off the list ;o(
>

this stuff was generated against my v4l-dvb-experimental repository it seems.

+		}
+		break;
+	case TUNER_XCEIVE_XC3028:
+		dprintk(KERN_INFO "saa7134_tuner_callback TUNER_XCEIVE_XC3028
command %d\n", command);
+		switch(command) {
+		case TUNER_RESET1:
+		case TUNER_RESET2:
+			/* this seems to be to correct bit */
+			saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x00008000, 0x00000000);
+			saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x00008000, 0x00008000);
+			break;
+
+		case TUNER_RESET3:
+			break;

this also needs a change to work with the linuxtv repository, that way
the patch is not compatible with the linuxtv.org repository it was
generated against my v4l-dvb-experimental repository.

You already have the xceive reset line bit. Look how other xc3028
reset callbacks are implemented into the linuxtv.org repository and
change this according to the other callbacks.

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
