Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n33Euokj001849
	for <video4linux-list@redhat.com>; Fri, 3 Apr 2009 10:56:50 -0400
Received: from mail-bw0-f170.google.com (mail-bw0-f170.google.com
	[209.85.218.170])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n33EtYx4018303
	for <video4linux-list@redhat.com>; Fri, 3 Apr 2009 10:56:01 -0400
Received: by bwz18 with SMTP id 18so1003771bwz.3
	for <video4linux-list@redhat.com>; Fri, 03 Apr 2009 07:55:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <412bdbff0904030747s3d1e956al168cc75b0208a3f0@mail.gmail.com>
References: <49D610CC.6070405@powercraft.nl>
	<412bdbff0904030747s3d1e956al168cc75b0208a3f0@mail.gmail.com>
Date: Fri, 3 Apr 2009 16:55:33 +0200
Message-ID: <d9def9db0904030755i1ea5c514p23f2556f37578a48@mail.gmail.com>
From: Markus Rechberger <mrechberger@gmail.com>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: request list of usb dvb-t devices that work with vanilla 2.6.29
	kernel
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

On Fri, Apr 3, 2009 at 4:47 PM, Devin Heitmueller
<devin.heitmueller@gmail.com> wrote:
> On Fri, Apr 3, 2009 at 9:36 AM, Jelle de Jong <jelledejong@powercraft.nl> wrote:
>> Hello everybody,
>>
>> I have been trying for years now to get support for usb based devices
>> that makes it possible to watch FTA dvb-t channels in Europa.
>>
>> I have bought more then 6 devices already and none of them work with the
>> stock vanilla kernel (or with fedora, debian kernel packages)
>>
>> I had hopes for the em28xx drivers, and spent a lots of time in the last
>> years to Markus Rechberger. I made documentation did testing, compiled
>> packages, did a lot of mailing and irc chats, etcetera.
>>
>> I always hoped the code and work would be merged back with the official
>> upstream kernel code so all this work would not be needed anymore and the
>> devices will all just work with the new kernel releases.
>>
>> I spent time sending emails and talking to developers to see how we could
>> help Markus get his code back into the kernel.
>>
>> But the situation is just sick, and there are real attitude issues on
>> both sides.
>>
>> I have gave up my hopes on getting a good healthy development process for
>> the em28xx project. I am kind of said about this, because I don't give up
>> easy and currently slowly feels that the em28xx project maybe hurting the
>> free software community more then its doing good...
>>
>> I now need new devices that do not need the em28xx code, I gave up hopes
>> on getting analog and dvb-t to work with one usb hybrid devices, so I am
>> going for a dvb-t only device.
>>
>> Can somebody help me provide a list of devices that i can buy in stores
>> and that are supported in the 2.6.29 stock kernel or have high
>> possibilities to get full support in the future.
>>
>> I would also like to point out I need a feature that allows scanning the
>> signal strength of a dvd-t channel so I can create an fully automated FTA
>> signal scanning systems that removes weaker supplicated channels.
>>
>> Best regards, (but kind of disappointed)
>>
>> Jelle de Jong
>
> Hello Jelle,
>
> I see an email like this every few months, and it continues to sadden
> me.  I'm not going to write yet another email casting blame on whose
> fault it is.  But let's look at what today's problems are and what
> would need to happen going forward.
>
> First off, the problem is not really the em28xx driver itself anymore.
>  The in-kernel driver itself is relatively mature and capable of
> handling new devices provided a new device profile is created in
> em28xx-cards.c.  I've pushed something like 45 patches in in the last
> year, and Mauro has pushed many more.  Empia has provided datasheets
> for em2860/em2880 and em2874, and the driver is pretty feature
> complete.  Support for a variety of new devices has been added in the
> last year.
>
> So what is the problem today?  Why do your devices not work?
>
> I believe the answer is a combination of two problems:
>
> 1.  A lack of driver support for Micronas demodulators - this is a
> sticky issue.  The Micronas demodulator is overly complicated relative
> to other demods, and there hasn't been an interest in investing the
> time to reverse engineer it (not when there are so many alternatives
> available that are much easier to program).  My efforts to get
> Micronas to allow me to release the reference driver code failed out
> of concern for "trade secrets and intellectual property concerns".
> The only reason those devices work in the mcentral.de tree is because
> he continues to redistribute their source code without a license.  If
> we had a proper license, I would be more than willing to merge this
> into the mainline.  With Empia using Micronas more and more in their
> newer reference designs, we should expect to see more products that
> fall into this category.
>

There are already some business customers who deployed Micronas based solutions
in a legal way.

> 2.  A lack of interest on the part of developers with access to DVB-T.
>  While support for ATSC based em28xx devices has grown considerably in
> the last year, there doesn't seem to be any developers with DVB-T who
> are interested in doing the work.  Many of the devices in question
> could be made to work with relatively little effort, but a developer
> needs to do the work to add the device profile (including the GPIOs)
> and iron out any integration bugs.  There haven't been any developers
> with both the hardware and access to DVB-T interested in stepping up
> to the task.
>

We currently make use of the crossover driver solution which moves the
drivers into userland
and even makes them work with the existing in-kernel as well as with
other unix based operating
systems. There are plenty of advantages starting with we can provide
one single driver for multiple
kernel versions - as long as the USB ID is in the driver the userland
crossoversolution will work with it
and improve its functionality.

Regards,
Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
