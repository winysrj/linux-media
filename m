Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5O9ED13002646
	for <video4linux-list@redhat.com>; Tue, 24 Jun 2008 05:14:13 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.234])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5O9E3Xd008548
	for <video4linux-list@redhat.com>; Tue, 24 Jun 2008 05:14:03 -0400
Received: by rv-out-0506.google.com with SMTP id f6so9060270rvb.51
	for <video4linux-list@redhat.com>; Tue, 24 Jun 2008 02:14:02 -0700 (PDT)
Message-ID: <e18c2fef0806240214v5d3f4c81g74b57077cdf1f413@mail.gmail.com>
Date: Tue, 24 Jun 2008 17:14:02 +0800
From: "Andrew Chuah" <hachuah@gmail.com>
To: "Andrew Chuah" <hachuah@gmail.com>, video4linux-list@redhat.com
In-Reply-To: <20080624074521.GB11578@daniel.bse>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <e18c2fef0806231913w2cab7de9yae74a9bdc7d04160@mail.gmail.com>
	<20080624074521.GB11578@daniel.bse>
Content-Transfer-Encoding: 8bit
Cc: 
Subject: Re: BTTV autodetection code - need help understanding.
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

Ah, silly me. Thanks for the explanation!

On Tue, Jun 24, 2008 at 3:45 PM, Daniel Glöckner <daniel-gl@gmx.net> wrote:
> On Tue, Jun 24, 2008 at 10:13:48AM +0800, Andrew Chuah wrote:
>> I am getting 0x00000000 for my cardid, which makes it skip the
>> autodetection step. Does anyone have any idea why this is happening?
>
> Old dmesg output in the list archive tells me that the GV250 does not
> have the EEPROM necessary for autodetection.
>
>> It shows up on lspci -nn as:
>>
>> 03:01.0 Multimedia video controller [0400]: Brooktree Corporation
>> Bt878 Video Capture [109e:036e] (rev 11)
>> 03:01.1 Multimedia controller [0480]: Brooktree Corporation Bt878
>> Audio Capture [109e:0878] (rev 11)
>
> The Subsystem IDs used for autodetection only show up when you pass -v to
> lspci. What you see are the PCI vendor and device IDs. These are the same
> for all Bt878 cards.
>
>  Daniel
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
