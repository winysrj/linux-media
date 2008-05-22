Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.227])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <drescherjm@gmail.com>) id 1JzEC5-0002GA-WE
	for linux-dvb@linuxtv.org; Thu, 22 May 2008 19:03:13 +0200
Received: by rv-out-0506.google.com with SMTP id b25so171337rvf.41
	for <linux-dvb@linuxtv.org>; Thu, 22 May 2008 10:03:05 -0700 (PDT)
Message-ID: <387ee2020805221003p3dc90120u87a9510daa3dbe54@mail.gmail.com>
Date: Thu, 22 May 2008 13:03:05 -0400
From: "John Drescher" <drescherjm@gmail.com>
To: KnightCode <knightcode@gmail.com>, linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <db218b6b0805220940q7f978785v6e4958df01fd681@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <db218b6b0805211928m6aeeae7ctffa6be5b7d90e9f9@mail.gmail.com>
	<387ee2020805211930j653a8240h8dc809b03d7a5942@mail.gmail.com>
	<db218b6b0805220940q7f978785v6e4958df01fd681@mail.gmail.com>
Subject: Re: [linux-dvb] Tuning Question, Comcast in Pittsburgh, PA
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

2008/5/22 KnightCode <knightcode@gmail.com>:
> Ok. So what can we do about this? I imagine TiVo and Slingbox don't have
> this problem (never used them, though) and the boxes from the cable company
> certainly don't have a problem, both of which probably just have some kind
> of digital signal processing that could be implemented on our CPU. If Nvidia
> can provide proprietary, binary drivers for their hardware, the major cable
> companies can do the same for their broadcasts. In fact, why aren't they
> made to? I'm allowed to timeshift transmissions in any way I see fit.
>

Tivo has a cable card inside it that will decrypt the encrypted
signal. I believe you have to pay $3 to $5 /month to comcast to
connect a cablecard device. There is no cable card on linux. The only
solution is to capture the output of a cable box. In the past this has
been only SD but Hauppage is releasing a new product that will allow
you to capture in HD. I believe the product exists but there are no
linux drivers yet.

John

John

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
