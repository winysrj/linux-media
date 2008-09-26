Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8QCIC6H032711
	for <video4linux-list@redhat.com>; Fri, 26 Sep 2008 08:18:12 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.153])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m8QCHt14016297
	for <video4linux-list@redhat.com>; Fri, 26 Sep 2008 08:17:55 -0400
Received: by fg-out-1718.google.com with SMTP id e21so662977fga.7
	for <video4linux-list@redhat.com>; Fri, 26 Sep 2008 05:17:54 -0700 (PDT)
Message-ID: <d9def9db0809260517p3ddef5bby47eb52d6bb1fa948@mail.gmail.com>
Date: Fri, 26 Sep 2008 14:17:54 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Salatiel Filho" <salatiel.filho@gmail.com>
In-Reply-To: <beb91d720809260508vc1e28d0m33daaa289c8cfe0b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7b6d682a0809251804j1277af44i80c53529a3c33d62@mail.gmail.com>
	<d9def9db0809251837k126b6b83n2803e56a00a7f961@mail.gmail.com>
	<7b6d682a0809251923uaacc119u25cf5118625c03d0@mail.gmail.com>
	<d9def9db0809251944g56462217sdc14a57c85db1b97@mail.gmail.com>
	<d9def9db0809260443w53d575b7s3857b424163ec1b@mail.gmail.com>
	<beb91d720809260508vc1e28d0m33daaa289c8cfe0b@mail.gmail.com>
Cc: video4linux-list@redhat.com, em28xx@mcentral.de
Subject: Re: Pinnacle PCTV HD Pro Stick
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

On Fri, Sep 26, 2008 at 2:08 PM, Salatiel Filho
<salatiel.filho@gmail.com> wrote:
> On Fri, Sep 26, 2008 at 8:43 AM, Markus Rechberger
> <mrechberger@gmail.com> wrote:
>> Hi,
>>
>> On Fri, Sep 26, 2008 at 4:44 AM, Markus Rechberger
>> <mrechberger@gmail.com> wrote:
>>> On Fri, Sep 26, 2008 at 4:23 AM, Eduardo Fontes
>>> <eduardo.fontes@gmail.com> wrote:
>>>> Hi Markus,
>>>>
>>>> Ok. The .deb package that you send to me + tvtime ".deb" package (
>>>> http://mcentral.de/tvtime/tvtime_1.0.2-1_i386.deb) my Pinnacle PCTV works
>>>> with sound, but only in b/w NTSC. Brazil is PAL-M color standard and when I
>>>> put in this TV Standard I get only noises and a disfigured green image. In
>>>> NTSC the image is clear but only in grey scale and sound is fine. Some patch
>>>> for this?
>>>>
>>>
>>> I'm going to update the package in a few hours with the latest code.
>>>
>>
>> Ok here's the updated i386 package:
>> http://mcentral.de/empia/20080926/empia-2.6.24-19-generic-8_i386.deb
>>
>> Markus
>>
>> --
>> video4linux-list mailing list
>> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>> https://www.redhat.com/mailman/listinfo/video4linux-list
>>
>
> Just curious , is there a way to get sound automatically using mplayer ?
>

not yet, although it's on the roadmap to provide patches for this too...
The patched tvtime version tries to get a list of available audio
devices and tries to connect
it automaticaly with the default audio output device and copies the
data from A to B.
This is why the tvtime version on mcentral.de has automated audio
support in general it
has a few more features so that it will work guaranteed with most
hardware even with bad graphic
drivers. I provided an X11 output driver in order to not depend on
hardware acceleration support
if support is not available. This X11 output plugin uses ffmpeg and
optimized CPU algorithms for
scaling.

You need to pass a parameter to mplayer, it's documented on mcentral.de

eg.:
    mplayer -vf pp=l5 -tv
driver=v4l2:outfmt=yuy2:width=720:height=576:fps=25:chanlist=europe-west:
    input=1:forceaudio:alsa:adevice=hw.2:immediatemode=0 tv://

you might search for foceaudio on mcentral.de it will show up a few
possibilities which endusers posted.

Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
