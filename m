Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m48Lshxb015502
	for <video4linux-list@redhat.com>; Thu, 8 May 2008 17:54:43 -0400
Received: from mailout01.t-online.de (mailout01.t-online.de [194.25.134.80])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m48LsVix006042
	for <video4linux-list@redhat.com>; Thu, 8 May 2008 17:54:31 -0400
Message-ID: <4823768D.4070405@t-online.de>
Date: Thu, 08 May 2008 23:54:21 +0200
From: Hartmut Hackmann <hartmut.hackmann@t-online.de>
MIME-Version: 1.0
To: Adam Glover <aglover.v4l@mindspring.com>
References: <5143530.1210229476468.JavaMail.root@mswamui-thinleaf.atl.sa.earthlink.net>
In-Reply-To: <5143530.1210229476468.JavaMail.root@mswamui-thinleaf.atl.sa.earthlink.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: odd behavior in tuner module in hg and linux stable
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

HI, Adam

Adam Glover schrieb:
> This has to do with the patch I submitted to add explicit
> support for the ADS Tech Instant HDTV PCI card (PTV-380).
> 
> It appears that in the latest kernel stable release as well
> as the hg snapshot I had used for the patch the tuner module
> does not identify the tuner chip on its initial automatic
> loadup.  I must rmmod and reinsert the tuner module before it
> will report detecting the TDA9887 / TUV1236D tuner chips.
> 
> This did not happen with version 2.6.24.4 so I'm wondering
> what changed?  As it stands, it's not fatal to have to remove
> and reinsert the module but it's not right...
> 
> This seems to be change from the last couple of months that
> has already made it into the stable kernel tree.
> 
> Incidentally, the dvb frontend loads and works despite the
> tuner having not registered the chips.  I just have no control
> over analog tuning.  I don't know if this is normal behavior
> or not.
> 
> So is this some sort of bug or is there something I should
> do with the card config when compiling the modules?
> 
> I'd like to see the card working (even though I have a pcHDTV
> card coming in the mail...)
> 
> Adam Glover
> 
> (I do apologize if I did not submit that patch correctly...
> I'm pretty sure I was wrong in not including relative paths
> and that the patch had to be run inside the saa7134 folder...)
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 

The cause of the problem migt be this changeset 7268:e7668fc3666c
in the v4l-dvb main repository. I have a problem with it as well.
The initialization order on hybrid cards is very critical.
So if it turns out that my hing is right, we need to discuss and
test this carefully.

Best regards
   Hartmut

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
