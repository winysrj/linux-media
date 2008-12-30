Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBUJ09IG022239
	for <video4linux-list@redhat.com>; Tue, 30 Dec 2008 14:00:09 -0500
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.236])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBUIxsig003601
	for <video4linux-list@redhat.com>; Tue, 30 Dec 2008 13:59:54 -0500
Received: by rv-out-0506.google.com with SMTP id f6so5583720rvb.51
	for <video4linux-list@redhat.com>; Tue, 30 Dec 2008 10:59:53 -0800 (PST)
Message-ID: <199bcede0812301059u6f83fe48ifb85de15feb473fe@mail.gmail.com>
Date: Tue, 30 Dec 2008 12:59:53 -0600
From: "David Lonie" <loniedavid@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: KWorld ATSC-115 problems
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

Nothing I can do seems to get this card to work -- I've been trying
for 4 days now, and I'm very lost as to how to troubleshoot the issue.
Here's a summary:

* Card is a KWorld ATSC-115 (using saa7134 drivers)
* I have a picture using xawtv to capture the analog signal
* I cannot change the channel
* There is no sound, even with saa7134-alsa loaded and xawtv set to
the correct dsp (/dev/dsp2 in my case).

If anyone out there is familiar with this card or troubleshooting this
driver, what would you do in this situation? I've tried several things
(see below) and I need help from the list to get it working. If there
is somewhere else I should be asking,  please let me know.

Thanks,

Dave


On Sun, Dec 28, 2008 at 6:37 PM, David Lonie <loniedavid@gmail.com> wrote:
> I recently started setting up a KWorld PlusTV ATSC-115 to work
> alongside my PVR-150 in a mythtv box.
>
> For the first few attempts at using it I got black screens in xawtv
> and myth. I followed the mythtv wiki, asked around on IRC and got
> nothing.
>
> Eventually (I have no idea what changed...) I got a picture! No sound,
> but I could see all the channel's from my analog cable signal in both
> myth and xawtv. I rebooted to see if this would work by default, and
> when I did I got static. I switched the cable from the top to the
> bottom connector and the picture came back (!). I have no clue why the
> card spontaneously changed inputs like that...
>
> Problem is, there's still no sound and I can't change channels. I'm
> stuck listening to some big-haired bimbo go on and on about who the
> sexiest tv doctor is on the charter channel.
>
> I fooled around a bit, trying the v4l hg drivers, the 2.6.27 drivers,
> etc, but no luck. I've reconfigured the card in myth a dozen times,
> unloaded and reloaded the module, etc. Any ideas what I should try
> next? Any output that may be useful to anyone? I've run out of ideas
> myself.
>
> Dave
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
