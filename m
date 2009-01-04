Return-path: <video4linux-list-bounces@redhat.com>
From: Andy Walls <awalls@radix.net>
To: Dale Pontius <DEPontius@edgehp.net>
In-Reply-To: <495E7328.6080600@edgehp.net>
References: <495E7328.6080600@edgehp.net>
Content-Type: text/plain
Date: Sun, 04 Jan 2009 13:08:12 -0500
Message-Id: <1231092492.3125.25.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-media@vger.kernel.org
Subject: Re: cx18 short-term resource available
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <linux-media.vger.kernel.org>

On Fri, 2009-01-02 at 15:03 -0500, Dale Pontius wrote:
> Every now and then I fix my sister-in-law an her husband's computer, and 
> every now and then they give me their cast-offs.  I also have 2 HVR-1600 
> cards and 2 SA4250C set-top boxes, only 1 of each in active use.  So for 
> a few months, I can bring back online a spare system, and can use some 
> spare time to assist.  I'll have to reinstall the machine, but it has a 
> valid XP-Home license, and can easily be made dual-boot.
> 
> So I have:
> Dell Dimension 2300, HVR2300, SA4250C, and can temporarily dedicate all 
> of this hardware to assist developers.  I know cx18 work seems to be 
> proceeding quite well on its own, but I also know that the IR blaster 
> seems to need work.  If I can be of assistance, please let me know.  I 
> can join the LIRC list, if appropriate.

Well, I haven't moved on making the IR blaster work better at all.
Users have reported that the modified lirc_pvr150 module and stock
lirc_pvr150 "firmware" image work.  It doesn't have the latest STB codes
though.

There was some email on one of the lists about 4-5 months ago for what
it would take to snoop off the new codes from the Zilog API in the
HVR-1600 Windows driver.  That would allow the lirc_pvr150 module to
support the newer STBs with the HVR-1600.

Ultimately, I want to get rid of the Zilog firmare in the blaster chip
and replace it with some home grown stuff.  I still have a ways to go on
that.



> Related, to Andy Walls,
> A few months back you were helping me, we couldn't find my tuner, and I 
> was essentially nowhere without that.  I took both HVR-1600 cards over 
> to a friend's house, and we plugged them into a WinXP machine, installed 
> drivers, and also got nowhere with either card.
> 
> I brought them home, plugged the second (the one I hadn't tried, yet) 
> card into my machine, and it was fully functional.  Then I plugged in 
> the first, and it was fully functional, as well.

Cool.  Dust/oxidation seems to really matter to proper PCI bus
operation.  When you get the chance, make sure all slots in you machine
are free of dust.  (I think it might matter to the PCI bus' reflected
wave signaling.)


>   In the past week I 
> read more, and learned how to scan for ATSC stations, and so far have 
> only QVC, but that's enough to verify that that side of one of the cards 
> works.  (I'll have to replug to test the ATSC on the other card, and 
> I've been leaving my hardware alone during the cold - and staticy snap.)

Try to use the best signal possible:

http://www.ivtvdriver.org/index.php/Howto:Improve_signal_quality

(I need to update that page to take into considerations for avoiding a
ground loop with the cable company, but that won't matter for OTA ATSC)


> Anyway, both cards work, I don't know if it was that they touched a 
> Windows machine and some secret bits got flipped by the Windows driver, 
> or if all I needed was a simple replug in the first place.

No.  There is no state saved on the card aside from in the ATMEL EEPROM
which should be write protected, and the EEPROM in the Zilog IR blater
chipw hich is a pain to write.

Most likely cleaning out dust and removing layers of oxidation/crud.



> Question:
> Under MythTV, the HVR-1600 seems - fuzzy.  My main card, a PixelPro, 
> seems sharper, though there are more artifacts in the video, also.  The 
> HVR-1600 seems cleaner, just fuzzy.  However, when I look at the 
> HVR-1600 video at native resolution, it seems quite good and the 
> fuzziness appears to be gone.
> 
> Do you know if this an artifact of how MythTV scales video to 
> fullscreen, or if there is something in the settings I should tweak?  I 
> have noticed that MythTV captures on the PixelPro at 480x480 by default, 
> and at that resolution HVR-1600 captures are less than half the file 
> size.  Changing the HVR-1600 captures to 720x480 improves things 
> somewhat, and the files are still smaller.

I don't know about the PixelPro, but the HVR-1600 is performing MPEG
compression (using hardware in the CX23418).  You may want to play with
the controls and view the results with mplayer until you're happy.

To list all the controls:

$ v4l2-ctl -d /dev/video0 -L

To get more help on maipulating the controls

$ v4l2-ctl --help


BTW: don't try MPEG-1 video encoding.  I found last night that it
doesn't appear to work.  Stick to MPEG-2 and play with the image size
and bit rates.

Regards,
Andy

> Thanks,
> Dale Pontius
> 
> --

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
