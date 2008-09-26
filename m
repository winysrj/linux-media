Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8QMP0am020563
	for <video4linux-list@redhat.com>; Fri, 26 Sep 2008 18:25:00 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.158])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8QMOkdf025816
	for <video4linux-list@redhat.com>; Fri, 26 Sep 2008 18:24:46 -0400
Received: by fg-out-1718.google.com with SMTP id e21so818298fga.7
	for <video4linux-list@redhat.com>; Fri, 26 Sep 2008 15:24:45 -0700 (PDT)
Message-ID: <d9def9db0809261524w565ce0afy780228090f44f99b@mail.gmail.com>
Date: Sat, 27 Sep 2008 00:24:45 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Roger Oberholtzer" <roger@opq.se>
In-Reply-To: <F79A917A-DA6D-47D8-B231-D2390610AA52@opq.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <7b6d682a0809251804j1277af44i80c53529a3c33d62@mail.gmail.com>
	<beb91d720809260508vc1e28d0m33daaa289c8cfe0b@mail.gmail.com>
	<d9def9db0809260517p3ddef5bby47eb52d6bb1fa948@mail.gmail.com>
	<d9def9db0809260537j2ff6fc98mc133ca37a06c1bc4@mail.gmail.com>
	<7b6d682a0809261234i71ea0fd5i6709fbc843f40768@mail.gmail.com>
	<d9def9db0809261239i45c7a9fbu8395a64b0c58bc73@mail.gmail.com>
	<2ee0f7430809261252v267626b4rc6269a6132cf88c0@mail.gmail.com>
	<d9def9db0809261311g303979adkf2c44ce44c932e3d@mail.gmail.com>
	<d9def9db0809261318x49812ce2g38b6b8b74448afd3@mail.gmail.com>
	<F79A917A-DA6D-47D8-B231-D2390610AA52@opq.se>
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: Pinnacle PCTV HD Pro Stick
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

On Sat, Sep 27, 2008 at 12:15 AM, Roger Oberholtzer <roger@opq.se> wrote:
>
> On Sep 26, 2008, at 10:18 PM, Markus Rechberger wrote:
>
> Time for a stupid question: I see that the device will capture HDTV
> (obviously). Does it also capture
> old fashioned analog NTSC (PAL in Europe)? The pinnacle site implies this.
> It is so?
>

remember the topic "Pinnacle PCTV HD Pro Stick" as far as I know pinnacle sold
this one as ATSC (american version of DVB-T - not compatible with europe).

But that version supports most worldwide standards I'm aware of
* PAL
* PAL-M (NTSC similar)
* NTSC
* SECAM

Pinnacle have had the 330e in their product line, they'll push hybrid
DVB-C/DVB-T/analogTV/radio
devices in future which will also be supported by the em28xx driver.

As for Europe there's Terratec with the Terratec Hybrid XS FM
(AnalogTV(stereo)/analog VBI(videotext)/
DVB-T/FM radio) currently available. I will check other companies in
Europe (although Pinnacle and Terratec
are pushing the linux support of those devices at the moment - the
future looks bright for people requesting
drivers in that area)

Markus


> Roger Oberholtzer
>
> OPQ Systems / Ramböll RST
>
> Ramböll Sverige AB
> Kapellgränd 7
> P.O. Box 4205
> SE-102 65 Stockholm, Sweden
>
> Office: Int +46 8-615 60 20
> Mobile: Int +46 70-815 1696
>
> And remember:
>
> It is RSofT and there is always something under construction.
> It is like talking about large city with all constructions finished.
> Not impossible, but very unlikely.
>
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
