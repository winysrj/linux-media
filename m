Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9MINgEs027975
	for <video4linux-list@redhat.com>; Wed, 22 Oct 2008 14:23:42 -0400
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9MINRXs026381
	for <video4linux-list@redhat.com>; Wed, 22 Oct 2008 14:23:28 -0400
Received: by ug-out-1314.google.com with SMTP id o38so1236305ugd.13
	for <video4linux-list@redhat.com>; Wed, 22 Oct 2008 11:23:22 -0700 (PDT)
Message-ID: <d9def9db0810221123s3cc27f6fhafcdb686df4a5bd9@mail.gmail.com>
Date: Wed, 22 Oct 2008 20:23:22 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
	em28xx@mcentral.de, "Linux and Kernel Video" <video4linux-list@redhat.com>
In-Reply-To: <d9def9db0810221038g156871e1u200abb90b774ad28@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9def9db0810221034v3bf4dabt6aa905b8a3ebd5a@mail.gmail.com>
	<d9def9db0810221038g156871e1u200abb90b774ad28@mail.gmail.com>
Cc: 
Subject: Re: [PATCH] em28xx patches against the latest git tree
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

On Wed, Oct 22, 2008 at 7:38 PM, Markus Rechberger
<mrechberger@gmail.com> wrote:
> On Wed, Oct 22, 2008 at 7:34 PM, Markus Rechberger
> <mrechberger@gmail.com> wrote:
>> Following patch adds the latest em28xx driver from mcentral.de.
>>
>> merging mcentral.de/hg/~mrec/em28xx-new with upstream kernel
>>
>> * adding VBI support to most VBI capable devices
>> * radio support for cx25843 based devices
>> * extra cx25843 driver (registers match the em28xx configuration in
>> order to support proper VBI)
>> * all videostandards and inputs are tested with cx25843 based devices
>> * adding alternative audio driver for em28xx devices (independent
>> audio transfer, not depending on oss/alsa)
>> * adding em28xx-webcam support for videology webcams
>> * adding em28xx-audioep audio driver for alternate number 1 - if
>> vendor specific and not USB audio conform
>> * adding s921 driver (ISDB-T 1Seg support tunneling parameters through
>> DVB-T API setting specific registers to auto)
>> * adding xc3028 mostly original sourcecode from the manufacturer (most
>> recent version), merged xc3028/xc3028l into
>>  one external firmware blob - important for signal quality
>> * adding xc5000 mostly original sourcecode from the manufacturer (most
>> recent version) - important for signal quality
>> * adding lgdt3304, although currently disabled
>> * remote control handling *works* but is broken by design and disabled
>> since different rc5/rc6/nec remotes return
>>  different values. Handling can be done using interrupt transfers too (TODO)
>> * fixed a couple of bugs in the em28xx-audio driver which can lead to
>> system hangs.
>>

one more thing which I forgot it also adds support for em2888 based
which also support
flash beside analog TV, digital TV and radio

>> ----
>>
>> as for testing:
>> * analog TV: patched tvtime (for analog TV) version available on
>> mcentral.de which supports 1. software rendering 2. digital
>> audio/alsa/aad
>> * FM radio: gqradio from mcentral.de, there's also an older radio
>> patch for vlc available.
>> * DVB-T: all applications should work with it
>> * ISDB-T: relevant for China and Brazil only, can be used with
>> dvbtune, dvbscan (the channel file cannot be used due problems with
>> the characters), for transferring the MPEG-TS stream dvbstream,
>> dvbsnoop, for playback gstreamer/mplayer (h264/aac isn't supported
>> well with it).
>>
>> commit history is available at:
>> http://mcentral.de/http://git.kernel.org/?p=linux/kernel/git/mrec/linux-2.6.git;a=commit;h=f1be9ae8f8489a6598417a194e0899ac00c7530ehg/~mrec/em28xx-new
>>
>
> this should be:
> http://mcentral.de/hg/~mrec/em28xx-new/shortlog
>
>> This patch adds a separate instance of the driver to the git
>> repository, not affecting anything existing.
>>
>> the full patch against the git repository:
>>
>>
>> Contributors:
>> user:        acano@fastmail.fm
>> user:        Andre Kelmanson <akelmanson@gmail.com>
>> user:        Bouwsma Barry <freebeer.bouwsma@gmail.com>
>> user:        Dan Kreiser <kreiser@informatik.hu-berlin.de>
>> user:        Frank Neuber <fn@kernelport.de>
>> user:        Jelle de Jong <jelledejong@powercraft.nl>
>> user:        John Stowers <john.stowers.lists@gmail.com>
>> user:        Lukas Kuna <lukas.kuna@evkanet.net>
>> user:        Stefan Vonolfen <stefan.vonolfen@gmail.com>
>> user:        Stephan Berberig <s.berberig@arcor.de>
>> user:        Thomas Giesecke <thomas.giesecke@ibgmbh-naumburg.de>
>> user:        Vitaly Wool <vwool@ru.mvista.com>
>> user:        Zhenyu Wang <zhen78@gmail.com>
>>
>> Signed-off-by: Markus Rechberger <mrechberger@sundtek.de>
>>
>

also adding video4linux-list

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
