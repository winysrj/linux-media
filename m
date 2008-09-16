Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8GHenIa001938
	for <video4linux-list@redhat.com>; Tue, 16 Sep 2008 13:40:49 -0400
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.184])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8GHe76P017067
	for <video4linux-list@redhat.com>; Tue, 16 Sep 2008 13:40:08 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1536856nfc.21
	for <video4linux-list@redhat.com>; Tue, 16 Sep 2008 10:40:07 -0700 (PDT)
Message-ID: <412bdbff0809161040q15f4e2bcxf52de6ebbe10664f@mail.gmail.com>
Date: Tue, 16 Sep 2008 13:40:07 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "eli hamels" <eli.hamels@gmail.com>
In-Reply-To: <48CFE85B.8050407@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48CFE85B.8050407@gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: Geniatech UTV3
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

On Tue, Sep 16, 2008 at 1:09 PM, eli hamels <eli.hamels@gmail.com> wrote:
> I guess somebody has to change the detection system to handle different
> devices with the same Vendor/Product ID.

FYI:  the em28xx driver does have the ability to handle different
devices with the same Vendor/Product ID.  See the em28xx_i2c_hash and
em28xx_eeprom_hash in em28xx_cards.c, used by the em28xx_hint_board()
function.

To use it, remove your entry from em28xx-cards.c, connect the device,
and the i2c hash will be shown in the dmesg output.  Then just add it
to the list.

Regards,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
