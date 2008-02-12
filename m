Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1C7rXEq002700
	for <video4linux-list@redhat.com>; Tue, 12 Feb 2008 02:53:33 -0500
Received: from rv-out-0910.google.com (rv-out-0910.google.com [209.85.198.188])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m1C7r8SP025976
	for <video4linux-list@redhat.com>; Tue, 12 Feb 2008 02:53:11 -0500
Received: by rv-out-0910.google.com with SMTP id k15so3722732rvb.51
	for <video4linux-list@redhat.com>; Mon, 11 Feb 2008 23:53:07 -0800 (PST)
Message-ID: <d9def9db0802112353m4a0c1d86h90007fd48f791ba2@mail.gmail.com>
Date: Tue, 12 Feb 2008 02:53:07 -0500
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Adam Pribyl" <pribyl@lowlevel.cz>
In-Reply-To: <Pine.LNX.4.64.0802120826060.26704@sandbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0802120826060.26704@sandbox.cz>
Cc: video4linux-list@redhat.com
Subject: Re: Lifeview NOT Hybrid PCI! LV3H
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Feb 12, 2008 2:48 AM, Adam Pribyl <pribyl@lowlevel.cz> wrote:
> I got this new card from Lifeview. It is based on Conexant CX-23881,
> Xceive 3028 tuner and Intel CE6353 DVBT decoder.. When
> I used cx88xx driver it segfaults, upon suggestion by Mauro Carvalho
> Chehab in this bug http://bugzilla.kernel.org/show_bug.cgi?id=9876 I
> compiled cx88 with xc3028 support from mercurial.
>
> Now it is better, driver identifies card as
> cx88[0]: subsystem: 14f1:8852, board: Geniatech X8000-MT DVBT
> [card=63,autodetected]
>
> and complains about
> xc2028 1-0061: xc2028/3028 firmware name not set!
> It is not loading xc firmware which I extracted into /lib/firmware
> according http://linuxtv.org/wiki/index.php/Xceive_XC3028/XC2028
>
> also it uses incorrect DVBT frontend
> DVB: registering frontend 0 (Zarlink ZL10353 DVB-T)...
>
> The questions:
> 1. How is that possible that subsystem id 14f1:8852 is matching this card
> but it is already known for different card - can we have two cards with
> same ID?
> 2. why xc is not loading firmware, looking into source it should load
> xc3028-v27.fw, where I can set the firmware name (any modprobe option?)
> 3. is intel DVBT supported?
>

Intel bought Zarlink, basically it's still a zl10353 but nowadays with
more accurate specs.

Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
