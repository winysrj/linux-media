Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7IJe1Hf019259
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 15:40:02 -0400
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.186])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7IJdSOC021898
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 15:39:52 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1242667nfc.21
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 12:39:51 -0700 (PDT)
Message-ID: <9e27f5bf0808181239j4d34aa12k9fb5cc46e9dbe2ed@mail.gmail.com>
Date: Mon, 18 Aug 2008 21:39:51 +0200
From: "litlle girl" <little.linux.girl@gmail.com>
To: video4linux-list@redhat.com
In-Reply-To: <20080817212205.GA1133@daniel.bse>
MIME-Version: 1.0
References: <9e27f5bf0808170627n556116d5rb0af4771c525af88@mail.gmail.com>
	<20080817212205.GA1133@daniel.bse>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Re: Kworld mpeg tv station / PCI [KW-TV878-FBKM]
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

>
> Try
> options bttv card=5 tuner=5 radio=1 pll=1 gpiomask=0x8007 audiomux=0,1,0,0
>   Daniel
>
 Thank you very much Daniel,
My TV card works with this options.
Maybe Kworld mpeg tv station / PCI [KW-TV878-FBKM] shuold be added to card
list at card=5?

Yours,
LLG
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
