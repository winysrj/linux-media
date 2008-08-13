Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.184])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1KTQ0n-0008AJ-Ic
	for linux-dvb@linuxtv.org; Thu, 14 Aug 2008 01:44:19 +0200
Received: by nf-out-0910.google.com with SMTP id g13so235929nfb.11
	for <linux-dvb@linuxtv.org>; Wed, 13 Aug 2008 16:44:13 -0700 (PDT)
Message-ID: <412bdbff0808131644p2d5f02bcqdd37ed800a5a13bc@mail.gmail.com>
Date: Wed, 13 Aug 2008 19:44:13 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: Xaero <kknull0@gmail.com>
In-Reply-To: <57ed08da0808111721v2d152865t5feee0c81cfaaf5c@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <57ed08da0808081449m598af353n7edf908551753318@mail.gmail.com>
	<412bdbff0808081458v418449c4q6db215cf83e3ead0@mail.gmail.com>
	<57ed08da0808111720j5514e218o2f4a17d2f4a954b7@mail.gmail.com>
	<57ed08da0808111721v2d152865t5feee0c81cfaaf5c@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Pinnacle pctv hybrid pro stick 340e support
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

2008/8/11 Xaero <kknull0@gmail.com>:
>
> ok,
> I've opened the card. The component are similar to 801e but they're not the
> same..
>
> -DibCom 700C1 - ACXXa-G
>  USB 2.0 DVB QHGG0
>  03M95.1
>  0809 - 1100 - C
> - XCeive 4000ACQ
>   DP5579
>   0805TWE3
> - Conexant CX25843 - 24Z
>   81038424
>   0804 KOREA
> - Cirrus 5340CZZ
>   0744

This is really useful information.  In particular, the fact that the
device uses an xc4000 instead of an xc5000 could be a problem.  The
V4L codebase has support for the xc2028, xc3028, and xc5000, but the
xc4000 is a (from what I understand) a reduced cost version of the
xc5000 that there is not currently support for.

Could you please take a few minutes and create a page on the Linux dvb
wiki for the device including the chipset information and the fact
that the device is not supported, so at least we have all the relevant
information.  You can use the 801e page as a starting point:

http://www.linuxtv.org/wiki/index.php/Pinnacle_PCTV_HD_Pro_Stick_(801e)

Perhaps the xc5000 maintainer he knows more about the xc4000 and how
significant the differences are.

Cheers,

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
