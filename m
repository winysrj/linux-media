Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5O2Dxok015445
	for <video4linux-list@redhat.com>; Mon, 23 Jun 2008 22:13:59 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.227])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5O2DnH2011607
	for <video4linux-list@redhat.com>; Mon, 23 Jun 2008 22:13:49 -0400
Received: by rv-out-0506.google.com with SMTP id f6so8895147rvb.51
	for <video4linux-list@redhat.com>; Mon, 23 Jun 2008 19:13:49 -0700 (PDT)
Message-ID: <e18c2fef0806231913w2cab7de9yae74a9bdc7d04160@mail.gmail.com>
Date: Tue, 24 Jun 2008 10:13:48 +0800
From: "Andrew Chuah" <hachuah@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: BTTV autodetection code - need help understanding.
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

Hi,

I'm trying to add my Geovision GV250 card to the list. It now works,
but autodetection doesn't. I'm trying to figure out why.
>From some printk statements, it looks like the problem is here in bttv-cards.c

pci_read_config_word(btv->c.pci, PCI_SUBSYSTEM_ID, &tmp);
btv->cardid = tmp << 16;
pci_read_config_word(btv->c.pci, PCI_SUBSYSTEM_VENDOR_ID, &tmp);
btv->cardid |= tmp;
printk(KERN_INFO "bttv: btv->cardid: %08x\n", btv->cardid);

I am getting 0x00000000 for my cardid, which makes it skip the
autodetection step. Does anyone have any idea why this is happening?
It shows up on lspci -nn as:

03:01.0 Multimedia video controller [0400]: Brooktree Corporation
Bt878 Video Capture [109e:036e] (rev 11)
03:01.1 Multimedia controller [0480]: Brooktree Corporation Bt878
Audio Capture [109e:0878] (rev 11)

thanks,
andrew

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
