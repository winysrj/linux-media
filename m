Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.245])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <owen.townend@gmail.com>) id 1KYvYK-00083G-NU
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 06:25:51 +0200
Received: by an-out-0708.google.com with SMTP id c18so112494anc.125
	for <linux-dvb@linuxtv.org>; Thu, 28 Aug 2008 21:25:35 -0700 (PDT)
Message-ID: <bb72339d0808282125g59a24920o6af8b41ccfa1f15c@mail.gmail.com>
Date: Fri, 29 Aug 2008 14:25:35 +1000
From: "Owen Townend" <owen.townend@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <48B59989.4080004@interia.pl>
MIME-Version: 1.0
Content-Disposition: inline
References: <48B59989.4080004@interia.pl>
Subject: Re: [linux-dvb] saa7162. Aver saa7135 cards. User stupid questions.
	More or less.
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

2008/8/28  <mincho@interia.pl>:
> Hi.
> saa7162
> Maybe thats really stupid question, but I greped and googled very
> intensive and I am not sure.
> What is recent status of saa7162 driver?
> Am I wrong - work is frozen due to missing specs?
> So should I assume - that schmeltz will not work under linux for long
> time more?
>
> Aver DVB-T Hybrid+FM PCI A16D.
> I found (on wiki page), that this card is poor supported.
> But I did not found 777 A16A-C at all.
> I have A16A-C and it works excellent.
> What is recent status for Hybrid+FM PCI A16D?
>
> Regards
> --
> Wieslaw Kirbedz

Hey,
 The wiki page for the AVerMedia DVB-T Hybrid+FM PCI (A16D) shows that
the card is actually well supported using the linuxtv repository. I
wrote/updated much of the A16D wiki section as I own one of these.
 Both digital and analogue work well (except for analogue audio under
Ubuntu - saa7134-alsa issues)
 I haven't yet tried to use the remote but there was a post earlier by
someone who is working on getting it mapped.

 If you have a new type of card that is working could you please
create a page for it in the wiki, add as much info as you can and add
it to the table here[1].

cheers,
Owen.

[0] http://www.linuxtv.org/wiki/index.php/AVerMedia_AVerTV_Hybrid%2BFM_PCI
[1] http://www.linuxtv.org/wiki/index.php/DVB-T_PCI_Cards

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
