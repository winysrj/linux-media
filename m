Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0D1Hjnk016870
	for <video4linux-list@redhat.com>; Mon, 12 Jan 2009 20:17:45 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.170])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0D1HVSc025857
	for <video4linux-list@redhat.com>; Mon, 12 Jan 2009 20:17:32 -0500
Received: by wf-out-1314.google.com with SMTP id 25so11477978wfc.6
	for <video4linux-list@redhat.com>; Mon, 12 Jan 2009 17:17:31 -0800 (PST)
Message-ID: <c785bba30901121717p2a822291u39524a21b61b7b42@mail.gmail.com>
Date: Mon, 12 Jan 2009 18:17:31 -0700
From: "Paul Thomas" <pthomas8589@gmail.com>
To: video4linux-list <video4linux-list@redhat.com>
In-Reply-To: <20090107235058.15bf6fa9@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c785bba30812301646vf7572dcua9361eb10ec58716@mail.gmail.com>
	<412bdbff0812311435n429787ecmbcab8de00ba05b6b@mail.gmail.com>
	<c785bba30812311444l65b3825aq844b79dd6f420c09@mail.gmail.com>
	<412bdbff0812311452o64538cdav4b948f6a9214ccdd@mail.gmail.com>
	<c785bba30901020850y51c7b9d2i47fd418828cd150c@mail.gmail.com>
	<c785bba30901030922y17d67d0bm822304a650a0e812@mail.gmail.com>
	<c785bba30901051633g7808197fl6d377420d799120c@mail.gmail.com>
	<c785bba30901070927x9be4bdcr84ceb792ccac7afb@mail.gmail.com>
	<412bdbff0901071024p7a16343cha01c09ea6ae2b5a2@mail.gmail.com>
	<20090107235058.15bf6fa9@pedra.chehab.org>
Subject: Re: em28xx issues
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

On Wed, Jan 7, 2009 at 6:50 PM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> On Wed, 7 Jan 2009 13:24:10 -0500
> "Devin Heitmueller" <devin.heitmueller@gmail.com> wrote:
>
>> A quick look at the code does show something interesting:
>>
>> There are a number of cases where we dereference the result of the
>> "INPUT" macro as follows without checking the number of inputs
>> defined:
>>
>> route.input = INPUT(index)->vmux;
>>
>> and here is the macro definition:
>>
>> #define INPUT(nr) (&em28xx_boards[dev->model].input[nr])
>>
>> It may be the case that a NULL pointer deference would occur if there
>> was only one input defined (as is the case for the PointNix camera).
>>
>> As a test, you might want to copy the other two inputs for the
>> PointNix device profile from some other device, and see if you still
>> hits an oops during input selection.
>
> I've reviewed the input stuff at em28xx driver, to avoid accessing input
> entries that aren't defined (so, filled with zeros).
>
> Cheers,
> Mauro
>

So, I'm finally able to get the source to compile again. I'm now using
a gcc 4.3.2 cross-compiler instead of a gcc 3.4.5. The three things
that make it work nicely are to use the "make release DIR=" command,
add "ARCH=arm CROSS_COMPILE=arm-unknown-gnu-" to the v4l-dvb make
command and finally run "make install" from the embedded side.

Anyway, I still get the oops with the latest tree. Also did some more
tests on my x86_64 box it looks like I have to run ucview before
fswebcam will work.

Is there any way this is being caused by improper ioctl calls from user-space?

The other thing that is odd is that there seems to be a need for some
physical memory. I have 512MB of swap space, but unless I have > 6MB
of physical memory I get a "Cannot allocate memory" error.

thanks,
Paul

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
