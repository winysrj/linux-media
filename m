Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.225])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <primijos@gmail.com>) id 1K4AFI-0005u5-IZ
	for linux-dvb@linuxtv.org; Thu, 05 Jun 2008 09:50:55 +0200
Received: by rv-out-0506.google.com with SMTP id b25so653295rvf.41
	for <linux-dvb@linuxtv.org>; Thu, 05 Jun 2008 00:50:47 -0700 (PDT)
Message-ID: <aea1a9c0806050050v4db695c6jef6b19421f617c4d@mail.gmail.com>
Date: Thu, 5 Jun 2008 09:50:47 +0200
From: "=?ISO-8859-1?Q?Jos=E9_Oliver_Segura?=" <primijos@gmail.com>
To: linux-dvb <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] dual tuner, different behaviour/signal strength problem
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

Hi all,

I've recently installed a mythbuntu box, with two USB tuners attached,
a Hauppauge nova-t and a pinnacle dual tuner. There's no problem with
the hauppauge, it works fine, but the pinnacle shows a strange
behaviour: it seems like the two tuners inside it are not "exact
twins", I mean: I have reception problems in one of them (frontend 1,
results being the one attached to the side antena connector, the
little one), which is unable to keep UNC to zero (thus, resulting in
audio/video glitches) depending on which channel is tuned on frontend
0 (the one attached to the back antenna connector).

They seem to work OK alone, but if I tune some specific channels on
tuner 0, tuner 1 starts to fail. This only happens for some specific
combinations (thus, most of the time I can watch/record two shows at
the same time with these tuners), but the combination that fails is,
for me, "THE" combination: tuesdays 10pm, tuner 1 recording "House
M.D." and tuner 0 recording "Prison Break" (the "House M.D." recording
is unwatchable due to the amount of glitches :-( )

Has anybody experienced similar behaviours with their tuner setup?
Does anybody knows a possible fix/workaround? I can provide as much
information as needed regarding the hardware/software setup.

Any help/advice would be welcome.

Best,
Jose

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
