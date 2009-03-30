Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2U8G7QL013182
	for <video4linux-list@redhat.com>; Mon, 30 Mar 2009 04:16:07 -0400
Received: from psi1.forpsi.com (smtpa.forpsi.com [81.2.195.204])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n2U8Dmm2024189
	for <video4linux-list@redhat.com>; Mon, 30 Mar 2009 04:13:49 -0400
Message-ID: <49D07F3B.3090807@heckler-koch.cz>
Date: Mon, 30 Mar 2009 10:13:47 +0200
From: "kosa@heckler-koch.cz" <kosa@heckler-koch.cz>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <49C8C0EF.1090500@heckler-koch.cz>
	<26aa882f0903241026n524b90f9w3898fa9aaaf0cd05@mail.gmail.com>
In-Reply-To: <26aa882f0903241026n524b90f9w3898fa9aaaf0cd05@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: multi channel
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

Jackson Yee wrote:
> 2009/3/24 kosa@heckler-koch.cz <kosa@heckler-koch.cz>:
>   
>> hi all, i am pretty new to video for linux. Last weekend i have successfully installed aver nv3000 (4 analog video-in pci card) on my debian machine. As i am new to video, i quickly found out that many cards have only one chip for 4 video inputs and work with signal as channels 1-4(as /dev/video0 witch 4 channels). My question is if there is some documentation or whatever where can i start to learn how to work with these multi channels to be able to view all 4 channels at the same time. When searching the web i found some software called zone minder, where they have the source in perl, so i hope i can understand their solution to use it in different place.
>>     
>
> Pavel,
>
> Here's a quick overview for you:
>
> * These multiple input cards are used mostly in surveillance systems
> where you have a number of cameras hooked up to one card. These cards
> are unsuitable for normal television capture unless you only want to
> do one input at a time because your frame rate will be divided between
> different channels (e.g. a normal 29.97 fps NTSC signal will become 7
> fps or less when you're using multiple inputs simultaneously). Cards
> do exist which have one chip per channel, but they are far more
> expensive.
>
> * The chip is normally a Brooktree BT878 because they're cheap and
> effective, although other chips are available. The Linux bttv driver
> does a good job of supporting most common cards, although some of the
> more esoteric ones aren't supported. For assured support,
> bluecherry.net is by far the best.
>
> * Zoneminder is a good program, and so is motion at
>
> http://www.lavrsen.dk/twiki/bin/view/Motion/WebHome
>
> They both have good documentation and performance. I have written my
> own web server in Python for motion which can be located at
>
> http://www.lavrsen.dk/twiki/bin/view/Motion/PossumCam
>
> although I have not had time to work on it recently. Zoneminder
> includes everything including the kitchen sink, and as such can be a
> pain to start working and managing. Motion is much simpler to install
> and manage, but requires add-on tools for further functionality.
>
> * For testing the inputs, TVTime and XawTV are indispensable.
>
> I'll try to add this information to the linuxtv.org wiki later on
> today, although any administrators familiar with the wiki are welcome
> to copy and paste the above.
>
> Regards,
> Jackson Yee
> The Possum Company
> 540-818-4079
> me@gotpossum.com
>
>   
Hi and thank you for links, will check it. For now i have obtain aver nv
5000 with 4 chips for 4 inputs(each 25fps). At this time i have only
tested 2 video inputs at the same time. I still have to investigate a
little bit as this card have Bt878 chip, for which i have to set Pan-Nc
settings in xawtv(but in vlc just setting  PAL makes the video not shown
correctly).
pavel


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
