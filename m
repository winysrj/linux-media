Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m97GZ8YU001843
	for <video4linux-list@redhat.com>; Tue, 7 Oct 2008 12:35:08 -0400
Received: from wx-out-0506.google.com (wx-out-0506.google.com [66.249.82.239])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m97GYpmO000780
	for <video4linux-list@redhat.com>; Tue, 7 Oct 2008 12:34:51 -0400
Received: by wx-out-0506.google.com with SMTP id h30so389148wxd.6
	for <video4linux-list@redhat.com>; Tue, 07 Oct 2008 09:34:51 -0700 (PDT)
Message-ID: <ea3b75ed0810070934y6fd6a720g42173e0b93eca578@mail.gmail.com>
Date: Tue, 7 Oct 2008 12:34:50 -0400
From: "Brian Phelps" <lm317t@gmail.com>
To: video4linux-list@redhat.com
In-Reply-To: <20081007145206.GA1664@daniel.bse>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <ea3b75ed0810070657i2f673bb1ub858b2871d7b387a@mail.gmail.com>
	<20081007145206.GA1664@daniel.bse>
Content-Transfer-Encoding: 8bit
Subject: Re: capture.c example (multiple inputs)
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

Hi Daniel,


On Tue, Oct 7, 2008 at 10:52 AM, Daniel Glöckner <daniel-gl@gmx.net> wrote:
> On Tue, Oct 07, 2008 at 09:57:28AM -0400, Brian Phelps wrote:
>> I did some digging and it looks like this single chip bt878 card must
>> cut the frame rate when switching inputs.  Is this correct?
>
> correct.
>
>> I found a 4-chip version from bluecherry.com that seems to do this at
>> full 30 FPS per channel.
>
> You mean .net, not .com?
Yes its bluecherry.net, I was in a hurry
>
> Be warned, depending on your system there may be dropped pixels when
> capturing four inputs at high resolution in inefficient color spaces.
> Especially when you try to write the videos to harddisk while the
> harddisk controller shares a PCI bus with the capture card.

Thanks for the advice Dan.
I am a bit of a newbie the concept of PCI buses. In this example (not
mine) is the 1e that the bt878 card is on, on a different bus than the
IDE controller, 1f?:
# lspci -tv
-[00]-+-00.0  Intel Corporation 82845G/GL[Brookdale-G]/GE/PE DRAM
Controller/Host-Hub Interface
      +-02.0  Intel Corporation 82845G/GL[Brookdale-G]/GE Chipset
Integrated Graphics Device
      +-1d.0  Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M)
USB UHCI Controller #1
      +-1d.1  Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M)
USB UHCI Controller #2
      +-1d.2  Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M)
USB UHCI Controller #3
      +-1d.7  Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2 EHCI Controller
      +-1e.0-[01]--+-02.0  Brooktree Corporation Bt878 Video Capture
      |            +-02.1  Brooktree Corporation Bt878 Audio Capture
      |            \-05.0  Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+
      +-1f.0  Intel Corporation 82801DB/DBL (ICH4/ICH4-L) LPC Interface Bridge
      +-1f.1  Intel Corporation 82801DB (ICH4) IDE Controller
      +-1f.3  Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M)
SMBus Controller
      \-1f.5  Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M)
AC'97 Audio Controller


>
>  Daniel
>



-- 
Brian Phelps
System Design Engineer
Custom Light and Sound
919-286-0011
http://customlightandsound.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
