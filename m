Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m594Yaj6026178
	for <video4linux-list@redhat.com>; Mon, 9 Jun 2008 00:34:37 -0400
Received: from mail9.dslextreme.com (mail9.dslextreme.com [66.51.199.94])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m594YPne015557
	for <video4linux-list@redhat.com>; Mon, 9 Jun 2008 00:34:25 -0400
Message-ID: <484CB2C1.10307@gimpelevich.san-francisco.ca.us>
Date: Sun, 08 Jun 2008 21:34:09 -0700
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <484CA80A.2050000@gimpelevich.san-francisco.ca.us>
	<484CABD6.6030800@gimpelevich.san-francisco.ca.us>
In-Reply-To: <484CABD6.6030800@gimpelevich.san-francisco.ca.us>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] Take 3: Implement proper cx88 deactivation
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

Daniel Gimpelevich wrote:
>  	switch (INPUT(input).type) {
> +	case CX88_RADIO:
> +		break;
>  	case CX88_VMUX_SVIDEO:
>  		cx_set(MO_AFECFG_IO,    0x00000001);

Of course, that break should be for both CX88_RADIO and CX88_OFF, but 
I'm reluctant to post a fourth copy of the patch just to add that one 
line. If this is to be committed, please add that appropriately. Thanks.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
