Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:51501 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092Ab0CSU0Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Mar 2010 16:26:16 -0400
Received: from dlep36.itg.ti.com ([157.170.170.91])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id o2JKQG8r020517
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 19 Mar 2010 15:26:16 -0500
Received: from dlep26.itg.ti.com (localhost [127.0.0.1])
	by dlep36.itg.ti.com (8.13.8/8.13.8) with ESMTP id o2JKQGqi005182
	for <linux-media@vger.kernel.org>; Fri, 19 Mar 2010 15:26:16 -0500 (CDT)
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "Rajashekhara, Sudhakar" <sudhakar.raj@ti.com>
Date: Fri, 19 Mar 2010 15:26:14 -0500
Subject: RE: [PATCH-V2 7/7] TVP514x: Add Powerup sequence during s_input to
 lock the signal properly
Message-ID: <A69FA2915331DC488A831521EAE36FE4016A6ECCD6@dlee06.ent.ti.com>
References: <hvaibhav@ti.com>
 <1268978653-32710-8-git-send-email-hvaibhav@ti.com>
 <A69FA2915331DC488A831521EAE36FE4016A6ECBC9@dlee06.ent.ti.com>
 <19F8576C6E063C45BE387C64729E7394044DE0E3FF@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E7394044DE0E3FF@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: multipart/mixed;
	boundary="_002_A69FA2915331DC488A831521EAE36FE4016A6ECCD6dlee06enttico_"
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--_002_A69FA2915331DC488A831521EAE36FE4016A6ECCD6dlee06enttico_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable


Vaibhav,

See my response with [MK] prefix.
>>
>[Hiremath, Vaibhav] Murali,
>
>I think I had already explained it to you, let me explain it again for
>broader audience.
>
>We are talking about two different issues here -
>
>- The default state of TVP514x after reset is active state, but when you
>execute streamoff then driver will put TVP514x into powered down state,
>which will cause locking issues when you try to S_INPUT next time. Since
>power on sequence will only be get executed during streamon.
>
>This is valid bug in the driver, which this patch addresses.

[MK]  Agree and I am okay with this patch and will sign-off
>
>- The second issue is related to auto switch feature and detected/set
>standard. The fix which you are talking about is putting TVP514x in auto
>switch mode in QUERYSTD. This is only required when application sets the
>standard explicitly and the spec says that the standard should not change
>unless set explicitly by the user. And since user is very well aware of
>what he is doing.
>

[MK] Ok. I looked back at your old email. Again the issue that I was referr=
ing to is failure to switch to a new standard in the following scenario:-


Input signal - NTSC
-------------------
Following sequence of call made to tvp driver:-

s_input()
query_std()
s_std() -> set the detected standard
stream on
stream off

Input signal changed to PAL

s_input() -> fails here

Here is what you had explained earlier (reproduced for discussion)

>2) Now we have 2 inputs, one with NTSC and other with PAL, the first >dete=
cted input will work without any issues, wince the signal has locked. >Say =
for example,

>First time you started streaming with CVBS-NTSC, with following sequence,

>S_INPUT (CVBS)
>QUERYSTD
>S_STD (NTSC)

>Now here you are explicitly setting the standard,

[MK] For S_STD ioctl, the vpfe_capture calls s_std() of tvp5146 to set the =
standard and if successful set the standard in the capture. So in this case
do you mean, the s_std call is causing the problem at tvp? Do you expect th=
e vpfe_capture not calling s_std() of tvp514x at all? Or should it call
query_std() instead when it is supported and s_std() when sub device doesn'=
t=20
have the query capability. In that case, why do we need s_std() at all. We
will be better of by removing that call.

>so when you again come back to s_input with S-Video (PAL), the TVP is not =
>going to lock the standard because, you did S_STD with NTSC in last attemp=
t.

[MK] So when you say tvp is not going to lock the standard, is it a hardwar=
e behavior? Here the s_input() is called and it fails because no signal loc=
ked at the input. IMO, since tvp has auto detect feature, it should enable =
auto detect every time there is a call to s_input and attempt to do auto de=
tection and shouldn't fail because last time user has set standard NTSC. =20

>The V4L2 spec says when user explicitly sets the standard then he is aware=
 >of what exactly he is doing and he has to take care of it.=20

[MK] Not sure what you mean by "he has to take care of it". Reboot the box =
to recover? If I understand you correctly, what you are saying is when the =
 input signal is NTSC and user sets standard to PAL what is the expected be=
havior. I think driver should do auto detect and gracefully returns -EINVAL=
 if the detected standard is different from user requested standard and sho=
uldn't result in a state where the board has to be rebooted.

>I had a good discussion with Hans on this; please refer to the link below
>
>http://www.mail-archive.com/linux-media@vger.kernel.org/msg11518.html
>
>I was about to re-initiate this thread, since we did not have any
>conclusion last time.

[MK] If required, you can re-initiate a separate thread to discuss this.

>
>I hope this clears all your doubts.
>
>Thanks,
>Vaibhav
>
>> Murali Karicheri
>> Software Design Engineer
>> Texas Instruments Inc.
>> Germantown, MD 20874
>> phone: 301-407-9583
>> email: m-karicheri2@ti.com
>>
>> >-----Original Message-----
>> >From: Hiremath, Vaibhav
>> >Sent: Friday, March 19, 2010 2:04 AM
>> >To: linux-media@vger.kernel.org
>> >Cc: Karicheri, Muralidharan; Hiremath, Vaibhav; Rajashekhara, Sudhakar
>> >Subject: [PATCH-V2 7/7] TVP514x: Add Powerup sequence during s_input to
>> >lock the signal properly
>> >
>> >From: Vaibhav Hiremath <hvaibhav@ti.com>
>> >
>> >For the sequence streamon -> streamoff and again s_input, it fails
>> >to lock the signal, since streamoff puts TVP514x into power off state
>> >which leads to failure in sub-sequent s_input.
>> >
>> >So add powerup sequence in s_routing (if disabled), since it is
>> >important to lock the signal at this stage.
>> >
>> >Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
>> >Signed-off-by: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
>> >---
>> > drivers/media/video/tvp514x.c |   13 +++++++++++++
>> > 1 files changed, 13 insertions(+), 0 deletions(-)
>> >
>> >diff --git a/drivers/media/video/tvp514x.c
>b/drivers/media/video/tvp514x.c
>> >index 26b4e71..97b7db5 100644
>> >--- a/drivers/media/video/tvp514x.c
>> >+++ b/drivers/media/video/tvp514x.c
>> >@@ -78,6 +78,8 @@ struct tvp514x_std_info {
>> > };
>> >
>> > static struct tvp514x_reg tvp514x_reg_list_default[0x40];
>> >+
>> >+static int tvp514x_s_stream(struct v4l2_subdev *sd, int enable);
>> > /**
>> >  * struct tvp514x_decoder - TVP5146/47 decoder object
>> >  * @sd: Subdevice Slave handle
>> >@@ -643,6 +645,17 @@ static int tvp514x_s_routing(struct v4l2_subdev *s=
d,
>> > 		/* Index out of bound */
>> > 		return -EINVAL;
>> >
>> >+	/*
>> >+	 * For the sequence streamon -> streamoff and again s_input
>> >+	 * it fails to lock the signal, since streamoff puts TVP514x
>> >+	 * into power off state which leads to failure in sub-sequent s_input=
.
>> >+	 *
>> >+	 * So power up the TVP514x device here, since it is important to lock
>> >+	 * the signal at this stage.
>> >+	 */
>> >+	if (!decoder->streaming)
>> >+		tvp514x_s_stream(sd, 1);
>> >+
>> > 	input_sel =3D input;
>> > 	output_sel =3D output;
>> >
>> >--
>> >1.6.2.4


--_002_A69FA2915331DC488A831521EAE36FE4016A6ECCD6dlee06enttico_
Content-Type: message/rfc822

From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>, "Hiremath, Vaibhav"
	<hvaibhav@ti.com>, "Jadav, Brijesh R" <brijesh.j@ti.com>
CC: "Narnakaje, Snehaprabha" <nsnehaprabha@ti.com>
Date: Thu, 25 Feb 2010 16:21:00 -0600
Subject: RE: NTSC-PAL switching...
Thread-Topic: NTSC-PAL switching...
Thread-Index: 
 Acq1prwD5cnWfF2fRfaO3YPv7ScbcQAAVnvAAAw9zEAAAv1gIAARfWAAAACL0eAAAve4sAAAmS9gAAGe0tAABa3vsAADqZ7g
References: <A69FA2915331DC488A831521EAE36FE4016A2D87DC@dlee06.ent.ti.com>
 <19F8576C6E063C45BE387C64729E7394044DA99AB5@dbde02.ent.ti.com>
 <19F8576C6E063C45BE387C64729E7394044DA99B21@dbde02.ent.ti.com>
 <A69FA2915331DC488A831521EAE36FE4016A2D890A@dlee06.ent.ti.com>
 <19F8576C6E063C45BE387C64729E7394044DA99D3F@dbde02.ent.ti.com>
  <A69FA2915331DC488A831521EAE36FE4016A2D8AA1@dlee06.ent.ti.com>
 <19F8576C6E063C45BE387C64729E7394044DA99D90@dbde02.ent.ti.com>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Content-Type: multipart/mixed;
	boundary="_002_7680727375697474656579736966697574757078687976656679687_"
MIME-Version: 1.0

--_002_7680727375697474656579736966697574757078687976656679687_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Vaibhav,

I have tested this one more time...

I see the same issue. I am also attaching the application that I used....
Check the function set_data_format(). This used the same sequence as
suggested by you...

S_INPUT
QUERYSTD
S_STD.

Send me your version of tvp514x, and I will try it tomorrow. It will be
great if we can discuss this tomorrow morning over phone so that we can hav=
e a quick resolution. I will be at my work around 9:30AM EST. If available,=
 What number can I reach you tomorrow morning?

regards,

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
phone: 301-407-9583
email: m-karicheri2@ti.com

>-----Original Message-----
>From: Karicheri, Muralidharan
>Sent: Thursday, February 25, 2010 3:33 PM
>To: Hiremath, Vaibhav; Jadav, Brijesh R
>Cc: Narnakaje, Snehaprabha
>Subject: RE: NTSC-PAL switching...
>
>Vaibhav,
>
>
>>> Vaibhav & Brijesh,
>>>
>>> I think we still need Brijesh's patch to get this working.
>>[Hiremath, Vaibhav] Logically it is not required; the change I sent you
>>should work.
>
>The code that I sent to you is from Arago tree. As far I Know, Brijesh
>has changed it recently to resolve the NTSC->PAL switching issue. I am
>attaching the version from Arago to this attachment..
>
>
>>I need to understand in details here. If you could send me exact steps yo=
u
>>are following then I could try it here at my end.
>
>I had mentioned the steps in my original email....
>
>1) Power On the evm (DM365)
>2) Play DVD NTSC video
>3) run the looback application for NTSC capture and display. The
>loopback runs fine for NTSC. stop the application (either cntrl-C or wait
>for application to exit)
>4) stop video and change the mode in DVD player to play PAL video. Wait
>for few minutes to have the DVD player play the video.
>5) re-run the application for PAL capture and display.
>
>In step 5) the query_std fails (no locking).
>
>>
>>> I am attaching
>>> the tvp514x.c that I use to this email. I am using the kernel from Arag=
o
>>> tree below. With this file, I am able to switch from NTSC -> PAL -> NTS=
C.
>>> So Could you send me a patch for this based on the tree below?
>>>
>>[Hiremath, Vaibhav] I do not have this tree cloned at my end, is tvp514x.=
c
>>driver under this tree different than available in main-line (which I
>>believe should not be)?
>>
>I have attached the version in Arago to this email. I will checkout one
>more
>time and let you know if I made any mistake....
>
>>
>>Thanks,
>>Vaibhav Hiremath
>>
>>> http://arago-project.org/git/people/sneha/linux-davinci-staging.git
>>>
>>>
>>> Murali Karicheri
>>> Software Design Engineer
>>> Texas Instruments Inc.
>>> Germantown, MD 20874
>>> phone: 301-407-9583
>>> email: m-karicheri2@ti.com
>>>
>>> >-----Original Message-----
>>> >From: Karicheri, Muralidharan
>>> >Sent: Thursday, February 25, 2010 11:46 AM
>>> >To: Hiremath, Vaibhav; Jadav, Brijesh R
>>> >Cc: Narnakaje, Snehaprabha
>>> >Subject: RE: NTSC-PAL switching...
>>> >
>>> >Vaibhav,
>>> >
>>> >Is this patch against the tvp514x.c in Arago tree? What happened to th=
e
>>fix
>>> >that Brijesh has put in tvp514x_s_routing()? Since I don't see the cod=
e
>>in
>>> >your diff below, I have removed that code from tvp514x_s_routing() and
>>> >replaced it with the one below. Also I have changed the application to
>>do
>>> >QUERYSTD followed by S_STD. I still get problem in switching from NTSC
>>to
>>> >PAL...
>>> >
>>> >Could you send me the tvp514x.c file that you are using along with the
>>> >application ?
>>> >
>>> >Murali Karicheri
>>> >Software Design Engineer
>>> >Texas Instruments Inc.
>>> >Germantown, MD 20874
>>> >phone: 301-407-9583
>>> >email: m-karicheri2@ti.com
>>> >
>>> >>-----Original Message-----
>>> >>From: Hiremath, Vaibhav
>>> >>Sent: Thursday, February 25, 2010 10:16 AM
>>> >>To: Karicheri, Muralidharan; Jadav, Brijesh R
>>> >>Cc: Narnakaje, Snehaprabha
>>> >>Subject: RE: NTSC-PAL switching...
>>> >>
>>> >>But as mentioned by Brijesh, the steps you are following is not
>correct.
>>> >>You may run into issues.
>>> >>
>>> >>Thanks,
>>> >>Vaibhav Hiremath
>>> >>
>>> >>> -----Original Message-----
>>> >>> From: Karicheri, Muralidharan
>>> >>> Sent: Thursday, February 25, 2010 8:29 PM
>>> >>> To: Jadav, Brijesh R; Hiremath, Vaibhav
>>> >>> Cc: Narnakaje, Snehaprabha
>>> >>> Subject: RE: NTSC-PAL switching...
>>> >>>
>>> >>> Brijesh & Vaibhav,
>>> >>>
>>> >>> Thanks for your patch.
>>> >>>
>>> >>> But the vpif application on Arago tree doesn't show this. I guess i=
t
>>> >>should
>>> >>> work both cases.
>>> >>>
>>> >>> Murali Karicheri
>>> >>> Software Design Engineer
>>> >>> Texas Instruments Inc.
>>> >>> Germantown, MD 20874
>>> >>> phone: 301-407-9583
>>> >>> email: m-karicheri2@ti.com
>>> >>>
>>> >>> >-----Original Message-----
>>> >>> >From: Jadav, Brijesh R
>>> >>> >Sent: Thursday, February 25, 2010 1:41 AM
>>> >>> >To: Hiremath, Vaibhav; Karicheri, Muralidharan
>>> >>> >Cc: Narnakaje, Snehaprabha
>>> >>> >Subject: RE: NTSC-PAL switching...
>>> >>> >
>>> >>> >Murali,
>>> >>> >
>>> >>> >I think the correct sequence to be followed in the application is
>>> >>S_INPUT,
>>> >>> >QUERYSTD and S_STD.
>>> >>> >
>>> >>> >Thanks,
>>> >>> >Brijesh Jadav
>>> >>> >
>>> >>> >-----Original Message-----
>>> >>> >From: Hiremath, Vaibhav
>>> >>> >Sent: Thursday, February 25, 2010 10:44 AM
>>> >>> >To: Karicheri, Muralidharan; Jadav, Brijesh R
>>> >>> >Cc: Narnakaje, Snehaprabha
>>> >>> >Subject: RE: NTSC-PAL switching...
>>> >>> >
>>> >>> >Murali,
>>> >>> >This issue has already been fixed and I (or Sudhakar) will send a
>>patch
>>> >>to
>>> >>> >list.
>>> >>> >
>>> >>> >The fix is something -
>>> >>> >
>>> >>> >diff --git a/drivers/media/video/tvp514x.c
>>> >>b/drivers/media/video/tvp514x.c
>>> >>> >index b344b58..0253d87 100644
>>> >>> >--- a/drivers/media/video/tvp514x.c
>>> >>> >+++ b/drivers/media/video/tvp514x.c
>>> >>> >@@ -78,6 +78,8 @@ struct tvp514x_std_info {
>>> >>> > };
>>> >>> >
>>> >>> > static struct tvp514x_reg tvp514x_reg_list_default[0x40];
>>> >>> >+
>>> >>> >+static int tvp514x_s_stream(struct v4l2_subdev *sd, int enable);
>>> >>> > /**
>>> >>> >  * struct tvp514x_decoder - TVP5146/47 decoder object
>>> >>> >  * @sd: Subdevice Slave handle
>>> >>> >@@ -658,6 +660,13 @@ static int tvp514x_s_routing(struct
>v4l2_subdev
>>> >*sd,
>>> >>> >                /* Index out of bound */
>>> >>> >                return -EINVAL;
>>> >>> >
>>> >>> >+       /*
>>> >>> >+        * For the sequence streamon -> streamoff and again s_inpu=
t,
>>> >>most
>>> >>> >of
>>> >>> >+        * the time it fails to lock the signal, since streamoff
>>puts
>>> >>> >TVP514x
>>> >>> >+        * into power off state which leads to failure in sub-
>>sequent
>>> >>> >s_input.
>>> >>> >+        */
>>> >>> >+       tvp514x_s_stream(sd, 1);
>>> >>> >+
>>> >>> >        input_sel =3D input;
>>> >>> >        output_sel =3D output;
>>> >>> >
>>> >>> >
>>> >>> >
>>> >>> >Hope this will help you.
>>> >>> >
>>> >>> >
>>> >>> >Thanks,
>>> >>> >Vaibhav Hiremath
>>> >>> >> -----Original Message-----
>>> >>> >> From: Karicheri, Muralidharan
>>> >>> >> Sent: Thursday, February 25, 2010 4:55 AM
>>> >>> >> To: Karicheri, Muralidharan; Hiremath, Vaibhav; Jadav, Brijesh R
>>> >>> >> Cc: Narnakaje, Snehaprabha
>>> >>> >> Subject: RE: NTSC-PAL switching...
>>> >>> >>
>>> >>> >> A quick update...
>>> >>> >>
>>> >>> >> I moved the while loop in tvp514x_s_routing() to querystd() and
>it
>>> >>seems
>>> >>> >to
>>> >>> >> work fine. I have tried switching from PAL->NTSC->PAL a couple o=
f
>>> >>times
>>> >>> >and
>>> >>> >> it worked fine.
>>> >>> >>
>>> >>> >> I know this is not the right fix. The root cause to fix is why
>the
>>> >>> >> tvp514x_s_routing() not able to detect the correct standard firs=
t
>>> >time.
>>> >>> >The
>>> >>> >> STD bits in the status registers seems to remember the last
>>standard
>>> >>> >> detected. Any comments ??
>>> >>> >>
>>> >>> >> Murali Karicheri
>>> >>> >> Software Design Engineer
>>> >>> >> Texas Instruments Inc.
>>> >>> >> Germantown, MD 20874
>>> >>> >> phone: 301-407-9583
>>> >>> >> email: m-karicheri2@ti.com
>>> >>> >>
>>> >>> >> >-----Original Message-----
>>> >>> >> >From: Karicheri, Muralidharan
>>> >>> >> >Sent: Wednesday, February 24, 2010 6:12 PM
>>> >>> >> >To: Hiremath, Vaibhav; Jadav, Brijesh R
>>> >>> >> >Cc: Narnakaje, Snehaprabha
>>> >>> >> >Subject: NTSC-PAL switching...
>>> >>> >> >
>>> >>> >> >Hi,
>>> >>> >> >
>>> >>> >> >There was an IR against this issue and it was fixed by Brijesh
>>> >though
>>> >>> >> >changes to tvp514x.c. I am running the latest release from Arag=
o
>>and
>>> >>> >> >I am running into the same issue.
>>> >>> >> >
>>> >>> >> >Here are the steps I am invoking...
>>> >>> >> >
>>> >>> >> >The evm input is composite and is connected to output of DVD
>>player.
>>> >>> >> >
>>> >>> >> >1) Power On the evm (DM365)
>>> >>> >> >2) Play DVD NTSC video
>>> >>> >> >3) run the looback application for NTSC capture and display. Th=
e
>>> >>> >loopback
>>> >>> >> >runs fine for NTSC. stop the application (either cntrl-C or wai=
t
>>for
>>> >>> >> >application to exit)
>>> >>> >> >4) stop video and change the mode in DVD player to play PAL
>video.
>>> >>Wait
>>> >>> >for
>>> >>> >> >few minutes to have the DVD player play the video.
>>> >>> >> >5) re-run the application for PAL capture and display.
>>> >>> >> >
>>> >>> >> >In step 5) the query_std fails (no locking). This was the
>>original
>>> >>issue
>>> >>> >> >and it continues to exist now even after the fix. I have
>verified
>>> >the
>>> >>> >patch
>>> >>> >> >that
>>> >>> >> >Brijesh has for this issue is in the build.
>>> >>> >> >
>>> >>> >> >After putting some debug prints, what I see is in
>>> >tvp514x_s_routing(),
>>> >>> >the
>>> >>> >> >video detected is whatever video played in the previous session
>>> >>though
>>> >>> >> >input has changed since then. Once driver reaches this state,
>>> >>query_std
>>> >>> >> >fails since it can't lock the carrier. During querystd, the
>video
>>> >>> >detected
>>> >>> >> >is correct, but the locking doesn't happen. Any idea why this
>>could
>>> >>be
>>> >>> >> >happening ?
>>> >>> >> >
>>> >>> >> >The application first call S_INPUT and set input to composite.
>It
>>> >>then
>>> >>> >> >calls S_STD and set standard. This is followed by QUERYSTD. I
>>have
>>> >>> >checked
>>> >>> >> >the vpif_userptr_loopback.c which does the same thing. Any help
>>to
>>> >>> >resolve
>>> >>> >> >this issue will be appreciated...
>>> >>> >> >
>>> >>> >> >Regards,
>>> >>> >> >
>>> >>> >> >Murali Karicheri
>>> >>> >> >Software Design Engineer
>>> >>> >> >Texas Instruments Inc.
>>> >>> >> >Germantown, MD 20874
>>> >>> >> >phone: 301-407-9583
>>> >>> >> >email: m-karicheri2@ti.com


--_002_7680727375697474656579736966697574757078687976656679687_
Content-Type: text/plain; name="v4l2_userptr_loopback.c"
Content-Description: v4l2_userptr_loopback.c
Content-Disposition: attachment; filename="v4l2_userptr_loopback.c";
	size=38033; creation-date="Thu, 25 Feb 2010 16:12:13 GMT";
	modification-date="Thu, 25 Feb 2010 16:12:13 GMT"
Content-Transfer-Encoding: base64

LyoKICogdjRsMl91c2VycHRyX2xvb3BiYWNrCiAqCiAqIENvcHlyaWdodCAoQykgMjAwOSBUZXhh
cyBJbnN0cnVtZW50cyBJbmNvcnBvcmF0ZWQgLSBodHRwOi8vd3d3LnRpLmNvbS8KICoKICoKICog
UmVkaXN0cmlidXRpb24gYW5kIHVzZSBpbiBzb3VyY2UgYW5kIGJpbmFyeSBmb3Jtcywgd2l0aCBv
ciB3aXRob3V0CiAqIG1vZGlmaWNhdGlvbiwgYXJlIHBlcm1pdHRlZCBwcm92aWRlZCB0aGF0IHRo
ZSBmb2xsb3dpbmcgY29uZGl0aW9ucwogKiBhcmUgbWV0OgogKgogKiBSZWRpc3RyaWJ1dGlvbnMg
b2Ygc291cmNlIGNvZGUgbXVzdCByZXRhaW4gdGhlIGFib3ZlIGNvcHlyaWdodAogKiBub3RpY2Us
IHRoaXMgbGlzdCBvZiBjb25kaXRpb25zIGFuZCB0aGUgZm9sbG93aW5nIGRpc2NsYWltZXIuCiAq
CiAqIFJlZGlzdHJpYnV0aW9ucyBpbiBiaW5hcnkgZm9ybSBtdXN0IHJlcHJvZHVjZSB0aGUgYWJv
dmUgY29weXJpZ2h0CiAqIG5vdGljZSwgdGhpcyBsaXN0IG9mIGNvbmRpdGlvbnMgYW5kIHRoZSBm
b2xsb3dpbmcgZGlzY2xhaW1lciBpbiB0aGUKICogZG9jdW1lbnRhdGlvbiBhbmQvb3Igb3RoZXIg
bWF0ZXJpYWxzIHByb3ZpZGVkIHdpdGggdGhlCiAqIGRpc3RyaWJ1dGlvbi4KICoKICogTmVpdGhl
ciB0aGUgbmFtZSBvZiBUZXhhcyBJbnN0cnVtZW50cyBJbmNvcnBvcmF0ZWQgbm9yIHRoZSBuYW1l
cyBvZgogKiBpdHMgY29udHJpYnV0b3JzIG1heSBiZSB1c2VkIHRvIGVuZG9yc2Ugb3IgcHJvbW90
ZSBwcm9kdWN0cyBkZXJpdmVkCiAqIGZyb20gdGhpcyBzb2Z0d2FyZSB3aXRob3V0IHNwZWNpZmlj
IHByaW9yIHdyaXR0ZW4gcGVybWlzc2lvbi4KICoKICogVEhJUyBTT0ZUV0FSRSBJUyBQUk9WSURF
RCBCWSBUSEUgQ09QWVJJR0hUIEhPTERFUlMgQU5EIENPTlRSSUJVVE9SUwogKiAiQVMgSVMiIEFO
RCBBTlkgRVhQUkVTUyBPUiBJTVBMSUVEIFdBUlJBTlRJRVMsIElOQ0xVRElORywgQlVUIE5PVAog
KiBMSU1JVEVEIFRPLCBUSEUgSU1QTElFRCBXQVJSQU5USUVTIE9GIE1FUkNIQU5UQUJJTElUWSBB
TkQgRklUTkVTUyBGT1IKICogQSBQQVJUSUNVTEFSIFBVUlBPU0UgQVJFIERJU0NMQUlNRUQuIElO
IE5PIEVWRU5UIFNIQUxMIFRIRSBDT1BZUklHSFQKICogT1dORVIgT1IgQ09OVFJJQlVUT1JTIEJF
IExJQUJMRSBGT1IgQU5ZIERJUkVDVCwgSU5ESVJFQ1QsIElOQ0lERU5UQUwsCiAqIFNQRUNJQUws
IEVYRU1QTEFSWSwgT1IgQ09OU0VRVUVOVElBTCBEQU1BR0VTIChJTkNMVURJTkcsIEJVVCBOT1QK
ICogTElNSVRFRCBUTywgUFJPQ1VSRU1FTlQgT0YgU1VCU1RJVFVURSBHT09EUyBPUiBTRVJWSUNF
UzsgTE9TUyBPRiBVU0UsCiAqIERBVEEsIE9SIFBST0ZJVFM7IE9SIEJVU0lORVNTIElOVEVSUlVQ
VElPTikgSE9XRVZFUiBDQVVTRUQgQU5EIE9OIEFOWQogKiBUSEVPUlkgT0YgTElBQklMSVRZLCBX
SEVUSEVSIElOIENPTlRSQUNULCBTVFJJQ1QgTElBQklMSVRZLCBPUiBUT1JUCiAqIChJTkNMVURJ
TkcgTkVHTElHRU5DRSBPUiBPVEhFUldJU0UpIEFSSVNJTkcgSU4gQU5ZIFdBWSBPVVQgT0YgVEhF
IFVTRQogKiBPRiBUSElTIFNPRlRXQVJFLCBFVkVOIElGIEFEVklTRUQgT0YgVEhFIFBPU1NJQklM
SVRZIE9GIFNVQ0ggREFNQUdFLgogKgoqLwovKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgoqKistLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLSsqKgoqKnwgICAgICAgICAgICAgICAgICAgICAgICAgICAgKioqKiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwqKgoqKnwgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgKioqKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHwqKgoqKnwgICAgICAgICAgICAgICAgICAgICAgICAgICAgKioqKioqbyoqKiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwqKgoqKnwgICAgICAgICAgICAgICAgICAgICAg
KioqKioqKipfLy8vXyoqKiogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwqKgoq
KnwgICAgICAgICAgICAgICAgICAgICAgKioqKiogL18vL18vICoqKiogICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHwqKgoqKnwgICAgICAgICAgICAgICAgICAgICAgICoqICoqIChf
Xy8gKioqKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwqKgoqKnwgICAgICAg
ICAgICAgICAgICAgICAgICAgICAqKioqKioqKiogICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIHwqKgoqKnwgICAgICAgICAgICAgICAgICAgICAgICAgICAgKioqKiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwqKgoqKnwgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgKioqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IHwqKgoqKnwgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHwqKgoqKnwgICAgICAgICBDb3B5cmlnaHQgKGMpIDE5
OTgtMjAwOCBUZXhhcyBJbnN0cnVtZW50cyBJbmNvcnBvcmF0ZWQgICAgICAgICAgIHwqKgoqKnwg
ICAgICAgICAgICAgICAgICAgICAgICBBTEwgUklHSFRTIFJFU0VSVkVEICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIHwqKgoqKnwgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwqKgoqKnwgUGVybWlzc2lv
biBpcyBoZXJlYnkgZ3JhbnRlZCB0byBsaWNlbnNlZXMgb2YgVGV4YXMgSW5zdHJ1bWVudHMgICAg
ICAgICAgIHwqKgoqKnwgSW5jb3Jwb3JhdGVkIChUSSkgcHJvZHVjdHMgdG8gdXNlIHRoaXMgY29t
cHV0ZXIgcHJvZ3JhbSBmb3IgdGhlIHNvbGUgICAgIHwqKgoqKnwgcHVycG9zZSBvZiBpbXBsZW1l
bnRpbmcgYSBsaWNlbnNlZSBwcm9kdWN0IGJhc2VkIG9uIFRJIHByb2R1Y3RzLiAgICAgICAgIHwq
KgoqKnwgTm8gb3RoZXIgcmlnaHRzIHRvIHJlcHJvZHVjZSwgdXNlLCBvciBkaXNzZW1pbmF0ZSB0
aGlzIGNvbXB1dGVyICAgICAgICAgIHwqKgoqKnwgcHJvZ3JhbSwgd2hldGhlciBpbiBwYXJ0IG9y
IGluIHdob2xlLCBhcmUgZ3JhbnRlZC4gICAgICAgICAgICAgICAgICAgICAgIHwqKgoqKnwgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIHwqKgoqKnwgVEkgbWFrZXMgbm8gcmVwcmVzZW50YXRpb24gb3Igd2FycmFu
dGllcyB3aXRoIHJlc3BlY3QgdG8gdGhlICAgICAgICAgICAgIHwqKgoqKnwgcGVyZm9ybWFuY2Ug
b2YgdGhpcyBjb21wdXRlciBwcm9ncmFtLCBhbmQgc3BlY2lmaWNhbGx5IGRpc2NsYWltcyAgICAg
ICAgIHwqKgoqKnwgYW55IHJlc3BvbnNpYmlsaXR5IGZvciBhbnkgZGFtYWdlcywgc3BlY2lhbCBv
ciBjb25zZXF1ZW50aWFsLCAgICAgICAgICAgIHwqKgoqKnwgY29ubmVjdGVkIHdpdGggdGhlIHVz
ZSBvZiB0aGlzIHByb2dyYW0uICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwqKgoq
KnwJCQkJCQkJCQkJCQkJCQkJCQkJIHwqKgoqKnwJRmlsZTogdjRsMl91c2VycHRyX2xvb3BiYWNr
LmMJCQkJCQkJCQkJCSAJIHwqKgoqKnwJCQkJCQkJCQkJCQkJCQkJCQkJIHwqKgoqKnwgRGVzY3Jp
cHRpb246IAkJCQkJCQkJCQkJCQkJCSB8KioKKip8CQkJCQkJCQkJCQkJCQkJCQkJCSB8KioKKip8
ICAgVGhpcyBpcyBhIHNhbXBsZSBsb29wYmFjayBhcHBsaWNhdGlvbiB0aGF0IHNlbnNlIHRoZSBp
bnB1dCB2aWRlbyAgICAgICB8KioKKip8IHN0YW5kYXJkIGF0IHRoZSBjb21wb3NpdGUgaW5wdXQg
YW5kIHBsYXkgdGhlIHNhbWUgZm9yIE5UU0MvUEFMIGRpc3BsYXkgICB8KioKKip8CWF0IHRoZSBj
b21wb3NpdGUgb3V0cHV0LiBUaGlzIHVzZXMgTU1BUCBJTyBmb3IgY2FwdHVyZSBhbmQgZGlzcGxh
eQkJIHwqKiAKKip8CWRyaXZlci4gCQkJCSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICB8KioKKip8ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8KioKKiorLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0rKioKKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKi8KLyoqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioKICoJSEVBREVSIEZJTEVTCiAqLwojaW5jbHVkZSA8c3RkaW8uaD4KI2luY2x1ZGUgPGZjbnRs
Lmg+CiNpbmNsdWRlIDxzdHJpbmcuaD4KI2luY2x1ZGUgPGdldG9wdC5oPgojaW5jbHVkZSA8c3Rk
bGliLmg+CiNpbmNsdWRlIDx1bmlzdGQuaD4KI2luY2x1ZGUgPGVycm5vLmg+CiNpbmNsdWRlIDxz
eXMvdHlwZXMuaD4KI2luY2x1ZGUgPHN5cy90aW1lLmg+CiNpbmNsdWRlIDxzeXMvbW1hbi5oPgoj
aW5jbHVkZSA8c3lzL2lvY3RsLmg+CiNpbmNsdWRlIDxmY250bC5oPgojaW5jbHVkZSA8bGludXgv
ZmIuaD4KI2luY2x1ZGUgPHRpbWUuaD4KCi8qIEtlcm5lbCBoZWFkZXIgZmlsZSwgcHJlZml4IHBh
dGggY29tZXMgZnJvbSBtYWtlZmlsZSAqLwojaW5jbHVkZSA8dmlkZW8vZGF2aW5jaWZiX2lvY3Rs
Lmg+CiNpbmNsdWRlIDx2aWRlby9kYXZpbmNpX29zZC5oPgojaW5jbHVkZSA8bGludXgvdmlkZW9k
ZXYuaD4KI2luY2x1ZGUgPGxpbnV4L3ZpZGVvZGV2Mi5oPgojaW5jbHVkZSA8bWVkaWEvZGF2aW5j
aS9kYXZpbmNpX2Rpc3BsYXkuaD4KI2luY2x1ZGUgPG1lZGlhL2RhdmluY2kvdmlkZW9oZC5oPgoK
LyoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioKICoJTE9DQUwgREVGSU5FUwogKi8KI2RlZmluZSBDQVBU
VVJFX0RFVklDRQkiL2Rldi92aWRlbzAiCgojZGVmaW5lIFdJRFRIX05UU0MJCTcyMAojZGVmaW5l
IEhFSUdIVF9OVFNDCQk0ODAKI2RlZmluZSBXSURUSF9QQUwJCTcyMAojZGVmaW5lIEhFSUdIVF9Q
QUwJCTU3NgojZGVmaW5lIFdJRFRIXzcyMFAJCTEyODAKI2RlZmluZSBIRUlHSFRfNzIwUAkJNzIw
CQojZGVmaW5lIFdJRFRIXzEwODBJCQkxOTIwCiNkZWZpbmUgSEVJR0hUXzEwODBJCQkxMDgwCgoj
ZGVmaW5lIE1JTl9CVUZGRVJTCTYKCiNkZWZpbmUgVVlWWV9CTEFDSwkweDEwODAxMDgwCgovKiBE
ZXZpY2UgcGFyYW1ldGVycyAqLwojZGVmaW5lIFZJRDBfREVWSUNFCSIvZGV2L3ZpZGVvMiIKI2Rl
ZmluZSBWSUQxX0RFVklDRQkiL2Rldi92aWRlbzMiCiNkZWZpbmUgT1NEMF9ERVZJQ0UJIi9kZXYv
ZmIwIgojZGVmaW5lIE9TRDFfREVWSUNFCSIvZGV2L2ZiMiIKCi8qIEZ1bmN0aW9uIGVycm9yIGNv
ZGVzICovCiNkZWZpbmUgU1VDQ0VTUwkJMAojZGVmaW5lIEZBSUxVUkUJCS0xCgovKiBCaXRzIHBl
ciBwaXhlbCBmb3IgdmlkZW8gd2luZG93ICovCiNkZWZpbmUgWVVWXzQyMl9CUFAJMTYKI2RlZmlu
ZSBCSVRNQVBfQlBQXzgJOAoKI2RlZmluZSBESVNQTEFZX0lOVEVSRkFDRV9DT01QT1NJVEUJIkNP
TVBPU0lURSIKI2RlZmluZSBESVNQTEFZX0lOVEVSRkFDRV9DT01QT05FTlQJIkNPTVBPTkVOVCIK
I2RlZmluZSBESVNQTEFZX01PREVfUEFMCSJQQUwiCiNkZWZpbmUgRElTUExBWV9NT0RFX05UU0MJ
Ik5UU0MiCiNkZWZpbmUgRElTUExBWV9NT0RFXzcyMFAJIjcyMFAtNjAiCQkKI2RlZmluZSBESVNQ
TEFZX01PREVfMTA4MEkJIjEwODBJLTMwIgkJCgojZGVmaW5lIHJvdW5kXzMyKHdpZHRoKQkoKCgo
d2lkdGgpICsgMzEpIC8gMzIpICogMzIgKQoKI2RlZmluZSBWSURFT19OVU1fQlVGUwk2CgovKiBT
dGFuZGFyZHMgYW5kIG91dHB1dCBpbmZvcm1hdGlvbiAqLwojZGVmaW5lIEFUVFJJQl9NT0RFCQki
bW9kZSIKI2RlZmluZSBBVFRSSUJfT1VUUFVUCQkib3V0cHV0IgoKI2RlZmluZSBMT09QX0NPVU5U
CQk1MDAKCiNkZWZpbmUgREVCVUcKI2lmZGVmIERFQlVHCiNkZWZpbmUgREJHRU5URVIgIAlwcmlu
dGYoIiVzIDogRW50ZXJcbiIsIF9fRlVOQ1RJT05fXyk7CiNkZWZpbmUgREJHRVhJVAkJcHJpbnRm
KCIlcyA6IExlYXZlXG4iLCBfX0ZVTkNUSU9OX18pOwojZGVmaW5lIFBSRVZfREVCVUcoeCkJcHJp
bnRmKCJERUJVRzolczolczolc1xuIixfX0ZVTkNUSU9OX18sX19MSU5FX18seCk7CiNlbHNlCiNk
ZWZpbmUgREJHRU5URVIKI2RlZmluZSBEQkdFWElUCiNkZWZpbmUgUFJFVl9ERUJVRyh4KQojZW5k
aWYKCiNkZWZpbmUgQ0xFQVIoeCkJbWVtc2V0ICgmKHgpLCAwLCBzaXplb2YgKHgpKQpzdGF0aWMg
aW50IGVuX2NhcHR1cmVfdG9fZmlsZTsKaW50IG51bV9mcmFtZV90b19jYXB0dXJlID0gMTAwOwoj
ZGVmaW5lIEZJTEVfQ0FQVFVSRSAiLi9vdXRwdXQueXV2IgpGSUxFICpmcF9jYXB0dXJlOwppbnQg
ZmlsZV9zaXplOwoKCi8qKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqCiAqCVNUUlVDVFVSRSBERUZJTklU
SU9OUwogKi8Kc3RydWN0IGJ1ZmZlciB7Cgl2b2lkICpzdGFydDsKCXNpemVfdCBsZW5ndGg7Cn07
CgovKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKgogKglGSUxFIEdMT0JBTFMKICovCnN0YXRpYyBpbnQg
ZmRDYXB0dXJlID0gLTE7CnN0YXRpYyBzdHJ1Y3QgYnVmZmVyICpidWZmZXJzLCB2aWQxQnVmW1ZJ
REVPX05VTV9CVUZTXTsKc3RhdGljIGludCBuQnVmZmVyczsKc3RhdGljIGludCBuV2lkdGhGaW5h
bDsKc3RhdGljIGludCBuSGVpZ2h0RmluYWw7CnN0YXRpYyBpbnQgcXVpdDsKc3RhdGljIGludCBm
ZF92aWQxLCBmZF9vc2QwLCBmZF9vc2QxOwpzdGF0aWMgaW50IGNyX3dpZHRoID0gMCwgY3JfaGVp
Z2h0ID0gMCwgY3JfdG9wID0gMCwgY3JfbGVmdCA9IDAsIGNyb3BfZW4gPSAwLCBzcmNfbGluZV9s
ZW4gPSAwOwpzdGF0aWMgaW50IHN0cmVzc190ZXN0ID0gMTsKc3RhdGljIGludCBzdGFydF9sb29w
Q250ID0gTE9PUF9DT1VOVDsKc3RhdGljIHN0cnVjdCB2NGwyX3JlcXVlc3RidWZmZXJzIHJlcWJ1
ZjsKc3RhdGljIGludCBkaXNwcGl0Y2gsIGRpc3BoZWlnaHQsIGRpc3B3aWR0aDsKc3RhdGljIGlu
dCBudW1idWZmZXJzID0gVklERU9fTlVNX0JVRlM7CnN0YXRpYyBzdHJ1Y3QgdjRsMl9jcm9wY2Fw
IGNyb3BjYXA7CnN0YXRpYyBpbnQgcHJpbnRmbiA9IDA7Ci8qIDAgLSBjb21wb3NpdGUKICogMSAt
IFMtdmlkZW8KICogMiAtIENhbWVyYQogKi8KaW50IHZwZmVfaW5wdXQgPSAwOwpzdGF0aWMgaW50
IGlucHV0X3N0ZDsKc3RhdGljIGludCBmaWVsZDsKY2hhciAqaW5wdXRzW10gPSB7ICJDT01QT1NJ
VEUiLCAiU1ZJREVPIiwgIkNPTVBPTkVOVCIgfTsKaW50IGRpc3BsYXlfaW1hZ2Vfc2l6ZSA9IDA7
CgovKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKgogKglFWFRFUk4gVkFSSUFCTEVTCiAqLwpleHRlcm4g
aW50IGVycm5vOwoKLyoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioKICoJTE9DQUwgRlVOQ1RJT04gUFJP
VE9UWVBFUwogKi8Kc3RhdGljIGludCBpbml0aWFsaXplX2NhcHR1cmUodjRsMl9zdGRfaWQgKiBj
dXJfc3RkKTsKc3RhdGljIGludCBwdXRfZGlzcGxheV9idWZmZXIoaW50LCBpbnQpOwpzdGF0aWMg
aW50IGdldF9kaXNwbGF5X2J1ZmZlcihpbnQpOwpzdGF0aWMgaW50IHN0b3BfZGlzcGxheShpbnQp
OwpzdGF0aWMgaW50IHJlbGVhc2VfZGlzcGxheShpbnQgKik7CnN0YXRpYyBpbnQgcmVsZWFzZV9j
YXB0dXJlKGludCAqKTsKc3RhdGljIGludCBzdG9wX2NhcHR1cmUoaW50KTsKc3RhdGljIGludCBz
dGFydF9sb29wKHZvaWQpOwpzdGF0aWMgaW50IGluaXRfY2FwdHVyZV9kZXZpY2Uodm9pZCk7CnN0
YXRpYyBpbnQgc2V0X2RhdGFfZm9ybWF0KHY0bDJfc3RkX2lkICogY3VyX3N0ZCk7CnN0YXRpYyBp
bnQgaW5pdF9jYXB0dXJlX2J1ZmZlcnModm9pZCk7CnN0YXRpYyBpbnQgc3RhcnRfc3RyZWFtaW5n
KHZvaWQpOwpzdGF0aWMgaW50IHN0YXJ0X2Rpc3BsYXkoaW50LCBpbnQsIGludCk7CnN0YXRpYyBp
bnQgaW5pdF92aWQxX2RldmljZSh2NGwyX3N0ZF9pZCBjdXJfc3RkKTsKc3RhdGljIGludCB2cGJl
X1VFXzEoKTsKc3RhdGljIGludCBjaGFuZ2Vfc3lzZnNfYXR0cmliKGNoYXIgKmF0dHJpYnV0ZSwg
Y2hhciAqdmFsdWUpOwoKLyoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioKICoJRlVOQ1RJT04gREVGSU5J
VElPTlMKICovCnN0YXRpYyBpbnQgaW5pdGlhbGl6ZV9jYXB0dXJlKHY0bDJfc3RkX2lkICogY3Vy
X3N0ZCkKewoJaW50IHJldDsKCXByaW50ZigiaW5pdGlhbGl6aW5nIGNhcHR1cmUgZGV2aWNlXG4i
KTsKCWluaXRfY2FwdHVyZV9kZXZpY2UoKTsKCXByaW50Zigic2V0dGluZyBkYXRhIGZvcm1hdFxu
Iik7CglyZXQgPSBzZXRfZGF0YV9mb3JtYXQoY3VyX3N0ZCk7CglpZiAocmV0KSB7CgkJcHJpbnRm
KCJFcnJvciBpbiBzZXR0aW5nIGNhcHR1cmUgZm9ybWF0XG4iKTsKCQlyZXR1cm4gcmV0OwoJfQoJ
cHJpbnRmKCJpbml0aWFsaXppbmcgY2FwdHVyZSBidWZmZXJzXG4iKTsKCXJldCA9IGluaXRfY2Fw
dHVyZV9idWZmZXJzKCk7CglpZiAocmV0KSB7CgkJcHJpbnRmKCJGYWlsZWQgdG8gaW5pdGlhbGl6
ZSBjYXB0dXJlIGJ1ZmZlcnNcbiIpOwoJCXJldHVybiByZXQ7Cgl9CglwcmludGYoImluaXRpYWxp
emluZyBkaXNwbGF5IGRldmljZVxuIik7CglyZXQgPSBzdGFydF9zdHJlYW1pbmcoKTsKCWlmIChy
ZXQpIHsKCQlwcmludGYoIkZhaWxlZCB0byBzdGFydCBjYXB0dXJlIHN0cmVhbWluZ1xuIik7CgkJ
cmV0dXJuIHJldDsKCX0KCXJldHVybiAwOwp9CgovKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgogKglU
YWtlcyB0aGUgYWRkcmVzcywgZmluZHMgdGhlIGFwcHJvcHJpYXRlIGluZGV4CiAqCW9mIHRoZSBi
dWZmZXIsIGFuZCBRVUVVRXMgdGhlIGJ1ZmZlciB0byBkaXNwbGF5CiAqCUlmIHRoaXMgcGFydCBp
cyBkb25lIGluIHRoZSBtYWluIGxvb3AsCiAqCXRoZXJlIGlzIG5vIG5lZWQgb2YgdGhpcyBjb252
ZXJzaW9ub2YgYWRkcmVzcwogKgl0byBpbmRleCBhcyBib3RoIGFyZSBhdmFpbGFibGUuCiAqLwpz
dGF0aWMgaW50IHB1dF9kaXNwbGF5X2J1ZmZlcihpbnQgdmlkX3dpbiwgaW50IGluZGV4KQp7Cglz
dHJ1Y3QgdjRsMl9idWZmZXIgYnVmOwoJaW50IGkgPSAwOwoJaW50IHJldDsKCgltZW1zZXQoJmJ1
ZiwgMCwgc2l6ZW9mKGJ1ZikpOwoKCWJ1Zi50eXBlID0gVjRMMl9CVUZfVFlQRV9WSURFT19PVVRQ
VVQ7CglidWYubWVtb3J5ID0gVjRMMl9NRU1PUllfVVNFUlBUUjsKCWJ1Zi5pbmRleCA9IGluZGV4
OwoJYnVmLmxlbmd0aCA9IGRpc3BsYXlfaW1hZ2Vfc2l6ZTsKCWJ1Zi5tLnVzZXJwdHIgPSAodW5z
aWduZWQgbG9uZylidWZmZXJzW2luZGV4XS5zdGFydDsKCglyZXQgPSBpb2N0bCh2aWRfd2luLCBW
SURJT0NfUUJVRiwgJmJ1Zik7CglyZXR1cm4gcmV0Owp9CgovKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KgogKglEb2VzIGEgREVRVUVVRSBhbmQgZ2V0cy9yZXR1cm5zIHRoZSBhZGRyZXNzIG9mIHRoZQog
KglkZXF1ZXVlZCBidWZmZXIKICovCnN0YXRpYyBpbnQgZ2V0X2Rpc3BsYXlfYnVmZmVyKGludCB2
aWRfd2luKQp7CglpbnQgcmV0OwoJc3RydWN0IHY0bDJfYnVmZmVyIGJ1ZjsKCW1lbXNldCgmYnVm
LCAwLCBzaXplb2YoYnVmKSk7CglidWYudHlwZSA9IFY0TDJfQlVGX1RZUEVfVklERU9fT1VUUFVU
OwoJcmV0ID0gaW9jdGwodmlkX3dpbiwgVklESU9DX0RRQlVGLCAmYnVmKTsKCWlmIChyZXQgPCAw
KSB7CgkJcGVycm9yKCJWSURJT0NfRFFCVUZcbiIpOwoJCXJldHVybiAtMTsKCX0KCXJldHVybiBi
dWYuaW5kZXg7Cn0KCi8qKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqCiAqCVN0b3BzIFN0cmVhbWluZwog
Ki8Kc3RhdGljIGludCBzdG9wX2Rpc3BsYXkoaW50IHZpZF93aW4pCnsKCWludCByZXQ7CgllbnVt
IHY0bDJfYnVmX3R5cGUgdHlwZTsKCXR5cGUgPSBWNEwyX0JVRl9UWVBFX1ZJREVPX09VVFBVVDsK
CXJldCA9IGlvY3RsKHZpZF93aW4sIFZJRElPQ19TVFJFQU1PRkYsICZ0eXBlKTsKCXJldHVybiBy
ZXQ7Cn0KCi8qKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqCiAqCVRoaXMgcm91dGluZSB1bm1hcHMgYWxs
IHRoZSBidWZmZXJzCiAqCVRoaXMgaXMgdGhlIGZpbmFsIHN0ZXAuCiAqLwpzdGF0aWMgaW50IHJl
bGVhc2VfZGlzcGxheShpbnQgKnZpZF93aW4pCnsKCWNsb3NlKCp2aWRfd2luKTsKCSp2aWRfd2lu
ID0gMDsKCXJldHVybiAwOwp9CgovKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgogKiAgICAgIFRoaXMg
cm91dGluZSB1bm1hcHMgYWxsIHRoZSBidWZmZXJzCiAqICAgICAgVGhpcyBpcyB0aGUgZmluYWwg
c3RlcC4KICovCnN0YXRpYyBpbnQgcmVsZWFzZV9jYXB0dXJlKGludCAqdmlkX3dpbikKewoJaW50
IGk7Cglmb3IgKGkgPSAwOyBpIDwgTUlOX0JVRkZFUlM7IGkrKykgewoJCW11bm1hcChidWZmZXJz
W2ldLnN0YXJ0LCBidWZmZXJzW2ldLmxlbmd0aCk7CgkJYnVmZmVyc1tpXS5zdGFydCA9IE5VTEw7
Cgl9CgljbG9zZSgqdmlkX3dpbik7CgkqdmlkX3dpbiA9IDA7CglyZXR1cm4gMDsKfQoKLyoqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioKICogICAgICBTdG9wcyBTdHJlYW1pbmcKICovCnN0YXRpYyBpbnQg
c3RvcF9jYXB0dXJlKGludCB2aWRfd2luKQp7CglpbnQgcmV0OwoJZW51bSB2NGwyX2J1Zl90eXBl
IHR5cGU7Cgl0eXBlID0gVjRMMl9CVUZfVFlQRV9WSURFT19DQVBUVVJFOwoJcmV0ID0gaW9jdGwo
dmlkX3dpbiwgVklESU9DX1NUUkVBTU9GRiwgJnR5cGUpOwoJcmV0dXJuIHJldDsKfQoKLyoqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKi8Kc3RhdGljIGludCBzdGFydF9sb29wKHZvaWQpCnsKCWludCByZXQs
IGRpc3BsYXlfaW5kZXg7CglzdHJ1Y3QgdjRsMl9idWZmZXIgYnVmOwoJc3RhdGljIGludCBjYXB0
RnJtQ250ID0gMDsKCXVuc2lnbmVkIGNoYXIgKmRpc3BsYXlidWZmZXIgPSBOVUxMOwoJaW50IGk7
CgljaGFyICpwdHJQbGFuYXIgPSBOVUxMOwoJdm9pZCAqc3JjLCAqZGVzdDsKCglwdHJQbGFuYXIg
PSAoY2hhciAqKWNhbGxvYygxLCBuV2lkdGhGaW5hbCAqIG5IZWlnaHRGaW5hbCAqIDIpOwoKCXdo
aWxlICghcXVpdCkgewoJCWZkX3NldCBmZHM7CgkJc3RydWN0IHRpbWV2YWwgdHY7CgkJaW50IHI7
CgoKCQlGRF9aRVJPKCZmZHMpOwoJCUZEX1NFVChmZENhcHR1cmUsICZmZHMpOwoKCQkvKiBUaW1l
b3V0ICovCgkJdHYudHZfc2VjID0gMjsKCQl0di50dl91c2VjID0gMDsKCQlyID0gc2VsZWN0KGZk
Q2FwdHVyZSArIDEsICZmZHMsIE5VTEwsIE5VTEwsICZ0dik7CgkJaWYgKC0xID09IHIpIHsKCQkJ
aWYgKEVJTlRSID09IGVycm5vKQoJCQkJY29udGludWU7CgkJCXByaW50ZigiU3RhcnRDYW1lcmFD
YXB0dXJlOnNlbGVjdFxuIik7CgkJCXJldHVybiAtMTsKCQl9CgkJaWYgKDAgPT0gcikKCQkJY29u
dGludWU7CgoJCUNMRUFSKGJ1Zik7CgkJYnVmLnR5cGUgPSBWNEwyX0JVRl9UWVBFX1ZJREVPX0NB
UFRVUkU7CgkJYnVmLm1lbW9yeSA9IFY0TDJfTUVNT1JZX01NQVA7CgoJCS8qIGRldGVybWluZSBy
ZWFkeSBidWZmZXIgKi8KCQlpZiAoLTEgPT0gaW9jdGwoZmRDYXB0dXJlLCBWSURJT0NfRFFCVUYs
ICZidWYpKSB7CgkJCWlmIChFQUdBSU4gPT0gZXJybm8pCgkJCQljb250aW51ZTsKCQkJcHJpbnRm
KCJTdGFydENhbWVyYUNhcHV0cmU6aW9jdGw6VklESU9DX0RRQlVGXG4iKTsKCQkJcmV0dXJuIC0x
OwoJCX0KCgkJaWYgKGVuX2NhcHR1cmVfdG9fZmlsZSkgewoJCQlpZiAoY2FwdEZybUNudCA9PSBu
dW1fZnJhbWVfdG9fY2FwdHVyZSkgewoJCQkJcHJpbnRmKCJXcml0aW5nIGZyYW1lICVkIHRvIGZp
bGUgJXMsIHNpemUgPSAlZFxuIixudW1fZnJhbWVfdG9fY2FwdHVyZSwKCQkJCQkgRklMRV9DQVBU
VVJFLCBmaWxlX3NpemUpOwoJCQkJZndyaXRlKGJ1ZmZlcnNbYnVmLmluZGV4XS5zdGFydCwgMSwg
ZmlsZV9zaXplLCBmcF9jYXB0dXJlKTsKCQkJCXByaW50ZigiV3JpdGluZyBmaWxlICVzIGNvbXBs
ZXRlXG4iLCBGSUxFX0NBUFRVUkUpOwoJCQkJZmNsb3NlKGZwX2NhcHR1cmUpOwoJCQl9CgkJfQoJ
CWlmIChjYXB0RnJtQ250IDw9IDEpIHsKCQkJCgkJCWlmICghY2FwdEZybUNudCkgewoJCQkJcHJp
bnRmKCI1LiBUZXN0IGVucXVlIGZpcnN0IGJ1ZmZlclxuIik7CgkJCQlyZXQgPSBzdGFydF9kaXNw
bGF5KGZkX3ZpZDEsIGJ1Zi5pbmRleCwgMCk7CgkJCX0KCQkJZWxzZSB7CgkJCQlwcmludGYoIjUu
IFRlc3QgZW5xdWUgc2Vjb25kIGJ1ZmZlclxuIik7CgkJCQlyZXQgPSBzdGFydF9kaXNwbGF5KGZk
X3ZpZDEsIGJ1Zi5pbmRleCwgMSk7CgkJCX0KCQkJaWYgKHJldCA8IDApIHsKCQkJCXByaW50Zigi
XHRFcnJvcjogU3RhcnRpbmcgZGlzcGxheSBmYWlsZWQ6VklEMVxuIik7CgkJCQlyZXR1cm4gcmV0
OwoJCQl9CgkJCWNhcHRGcm1DbnQrKzsKCQkJY29udGludWU7CgkJfQoJCQoJCXJldCA9IHB1dF9k
aXNwbGF5X2J1ZmZlcihmZF92aWQxLCBidWYuaW5kZXgpOwoJCWlmIChyZXQgPCAwKSB7CgkJCXBy
aW50ZigiRXJyb3IgaW4gcHV0dGluZyB0aGUgZGlzcGxheSBidWZmZXJcbiIpOwoJCQlyZXR1cm4g
cmV0OwoJCX0KCgkJLyoqKioqKioqKioqKioqKioqKiogVjRMMiBkaXNwbGF5ICoqKioqKioqKioq
KioqKioqKioqLwoJCWRpc3BsYXlfaW5kZXggPSBnZXRfZGlzcGxheV9idWZmZXIoZmRfdmlkMSk7
CgkJaWYgKGRpc3BsYXlfaW5kZXggPCAwKSB7CgkJCXByaW50ZigiRXJyb3IgaW4gZ2V0dGluZyB0
aGUgIGRpc3BsYXkgYnVmZmVyOlZJRDFcbiIpOwoJCQlyZXR1cm4gcmV0OwoJCX0KCQkvKioqKioq
KioqKioqKioqKiogRU5EIFY0TDIgZGlzcGxheSAqKioqKioqKioqKioqKioqKiovCgoJCQoJCWlm
IChwcmludGZuKQoJCQlwcmludGYoInRpbWU6JWx1ICAgIGZyYW1lOiV1XG4iLCAodW5zaWduZWQg
bG9uZyl0aW1lKE5VTEwpLAoJCSAgICAgICAJCWNhcHRGcm1DbnQrKyk7CgoJCWJ1Zi5pbmRleCA9
IGRpc3BsYXlfaW5kZXg7CgkJLyogcmVxdWV1ZSB0aGUgYnVmZmVyICovCgkJaWYgKC0xID09IGlv
Y3RsKGZkQ2FwdHVyZSwgVklESU9DX1FCVUYsICZidWYpKQoJCQlwcmludGYoIlN0YXJ0Q2FtZXJh
Q2FwdXRyZTppb2N0bDpWSURJT0NfUUJVRlxuIik7CgkJaWYgKHN0cmVzc190ZXN0KSB7CgkJCXN0
YXJ0X2xvb3BDbnQtLTsKCQkJaWYgKHN0YXJ0X2xvb3BDbnQgPT0gMCkgewoJCQkJc3RhcnRfbG9v
cENudCA9IDUwOwoJCQkJYnJlYWs7CgkJCX0KCQl9Cgl9CgoJcmV0dXJuIHJldDsKfQoKLyoqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKi8Kc3RhdGljIGludCBpbml0X2NhcHR1cmVfZGV2aWNlKHZvaWQpCnsK
CXN0cnVjdCB2NGwyX2NhcGFiaWxpdHkgY2FwOwoKCS8qIGlucHV0LTAgaXMgc2VsZWN0ZWQgYnkg
ZGVmYXVsdCwgc28gbm8gbmVlZCB0byBzZXQgaXQgKi8KCWlmICgoZmRDYXB0dXJlID0gb3BlbihD
QVBUVVJFX0RFVklDRSwgT19SRFdSLCAwKSkgPD0gLTEpIHsKCQlwcmludGYoIkluaXREZXZpY2U6
b3Blbjo6XG4iKTsKCQlyZXR1cm4gLTE7Cgl9CgoJLyogaXMgY2FwdHVyZSBzdXBwb3J0ZWQ/ICov
CglpZiAoLTEgPT0gaW9jdGwoZmRDYXB0dXJlLCBWSURJT0NfUVVFUllDQVAsICZjYXApKSB7CgkJ
cHJpbnRmKCJJbml0RGV2aWNlOmlvY3RsOlZJRElPQ19RVUVSWUNBUDpcbiIpOwoJCXJldHVybiAt
MTsKCX0KCglpZiAoIShjYXAuY2FwYWJpbGl0aWVzICYgVjRMMl9DQVBfVklERU9fQ0FQVFVSRSkp
IHsKCQlwcmludGYoIkluaXREZXZpY2U6Y2FwdHVyZSBpcyBub3Qgc3VwcG9ydGVkIG9uOiVzXG4i
LAoJCSAgICAgICBDQVBUVVJFX0RFVklDRSk7CgkJcmV0dXJuIC0xOwoJfQoKCS8qIGlzIE1NQVAt
SU8gc3VwcG9ydGVkPyAqLwoJaWYgKCEoY2FwLmNhcGFiaWxpdGllcyAmIFY0TDJfQ0FQX1NUUkVB
TUlORykpIHsKCQlwcmludGYoIkluaXREZXZpY2U6SU8gbWV0aG9kIE1NQVAgaXMgbm90IHN1cHBv
cnRlZCBvbjolc1xuIiwKCQkgICAgICAgQ0FQVFVSRV9ERVZJQ0UpOwoJCXJldHVybiAtMTsKCX0K
CglyZXR1cm4gMDsKfQoKLyoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKi8Kc3RhdGljIGludCBzZXRfZGF0
YV9mb3JtYXQodjRsMl9zdGRfaWQgKiBjdXJfc3RkKQp7Cgl2NGwyX3N0ZF9pZCBwcmV2X3N0ZDsK
CXN0cnVjdCB2NGwyX2Zvcm1hdCBmbXQ7Cgl1bnNpZ25lZCBpbnQgbWluOwoJc3RydWN0IHY0bDJf
aW5wdXQgaW5wdXQ7CglpbnQgdGVtcF9pbnB1dDsKCXN0cnVjdCB2NGwyX2Nyb3BjYXAgY3JvcGNh
cDsKCXN0cnVjdCB2NGwyX2Nyb3AgY3JvcDsKCXN0cnVjdCB2NGwyX2ZtdGRlc2MgZm10X2Rlc2M7
CglzdHJ1Y3QgdjRsMl9zdGFuZGFyZCBzdGFuZGFyZDsKCWludCByZXQ7CgoJLy8gZmlyc3Qgc2V0
IHRoZSBpbnB1dAoJaW5wdXQudHlwZSA9IFY0TDJfSU5QVVRfVFlQRV9DQU1FUkE7CglpbnB1dC5p
bmRleCA9IDA7CiAgCXdoaWxlICgocmV0ID0gaW9jdGwoZmRDYXB0dXJlLFZJRElPQ19FTlVNSU5Q
VVQsICZpbnB1dCkgPT0gMCkpIHsgCgkJcHJpbnRmKCJpbnB1dC5uYW1lID0gJXNcbiIsIGlucHV0
Lm5hbWUpOwoJCWlmICgodnBmZV9pbnB1dCA9PSAwKSAmJiAhc3RyY21wKGlucHV0Lm5hbWUsICJD
b21wb3NpdGUiKSkKCQkJYnJlYWs7CgkJaWYgKCh2cGZlX2lucHV0ID09IDEpICYmICFzdHJjbXAo
aW5wdXQubmFtZSwgIlMtVmlkZW8iKSkKCQkJYnJlYWs7CgkJaWYgKCh2cGZlX2lucHV0ID09IDIp
ICYmICFzdHJjbXAoaW5wdXQubmFtZSwgIkNhbWVyYSIpKQoJCQlicmVhazsKCQlpZiAoKHZwZmVf
aW5wdXQgPT0gMykgJiYgIXN0cmNtcChpbnB1dC5uYW1lLCAiQ29tcG9uZW50IikpCgkJCWJyZWFr
OwoJCWlucHV0LmluZGV4Kys7CiAgCX0KCglpZiAocmV0IDwgMCkgewoJCXByaW50ZigiQ291bGRu
J3QgZmluZCB0aGUgaW5wdXRcbiIpOwoJCXJldHVybiAtMTsKCX0KCglwcmludGYoIkNhbGxpbmcg
U19JTlBVVCB3aXRoIGluZGV4ID0gJWRcbiIsIGlucHV0LmluZGV4KTsKICAJaWYgKC0xID09IGlv
Y3RsIChmZENhcHR1cmUsIFZJRElPQ19TX0lOUFVULCAmaW5wdXQuaW5kZXgpKQogIAl7CgkJcGVy
cm9yKCJFcnJvcjpJbml0RGV2aWNlOmlvY3RsOlZJRElPQ19TX0lOUFVUXG4iKTsKICAgICAgCQly
ZXR1cm4gLTE7CiAgCX0KICAJcHJpbnRmICgiSW5pdERldmljZTppb2N0bDpWSURJT0NfU19JTlBV
VCwgc2VsZWN0ZWQgaW5wdXQgaW5kZXggPSAlZFxuIiwKCQlpbnB1dC5pbmRleCk7CgoJaWYgKC0x
ID09IGlvY3RsIChmZENhcHR1cmUsIFZJRElPQ19HX0lOUFVULCAmdGVtcF9pbnB1dCkpCgl7CgkJ
cGVycm9yKCJFcnJvcjpJbml0RGV2aWNlOmlvY3RsOlZJRElPQ19HX0lOUFVUXG4iKTsKCQlyZXR1
cm4gLTE7Cgl9CgkKCWlmICh0ZW1wX2lucHV0ID09IGlucHV0LmluZGV4KQoJCXByaW50ZiAoIklu
aXREZXZpY2U6aW9jdGw6VklESU9DX0dfSU5QVVQsIHNlbGVjdGVkIGlucHV0LCAlc1xuIiwgaW5w
dXQubmFtZSk7CgllbHNlIHsKCQlwcmludGYgKCJFcnJvcjogSW5pdERldmljZTppb2N0bDpWSURJ
T0NfR19JTlBVVCwiKTsKCQlwcmludGYoIkNvdWxkbid0IHNlbGVjdCAlcyBpbnB1dFxuIiwgaW5w
dXQubmFtZSk7CgkJcmV0dXJuIC0xOwogIAl9CgoJcHJpbnRmKCJGb2xsb3dpbmcgc3RhbmRhcmRz
IGF2YWlsYWJsZSBhdCB0aGUgaW5wdXRcbiIpOwoJc3RhbmRhcmQuaW5kZXggPSAwOwoJaWYgKHZw
ZmVfaW5wdXQgIT0gMykgewoJCXdoaWxlICgwID09IGlvY3RsIChmZENhcHR1cmUsIFZJRElPQ19F
TlVNU1RELCAmc3RhbmRhcmQpKSB7CgkJCXByaW50Zigic3RhbmRhcmQuaW5kZXggPSAlZFxuIiwg
c3RhbmRhcmQuaW5kZXgpOwoJCQlwcmludGYoInN0YW5kYXJkLmlkID0gJWxseFxuIiwgc3RhbmRh
cmQuaWQpOwoJCQlwcmludGYoInN0YW5kYXJkLmZyYW1lcGVyaW9kLm51bWVyYXRvciA9ICVkXG4i
LAoJCQkJc3RhbmRhcmQuZnJhbWVwZXJpb2QubnVtZXJhdG9yKTsKCQkJcHJpbnRmKCJzdGFuZGFy
ZC5mcmFtZXBlcmlvZC5kZW5vbWluYXRvciA9ICVkXG4iLAoJCQkJc3RhbmRhcmQuZnJhbWVwZXJp
b2QuZGVub21pbmF0b3IpOwoJCQlwcmludGYoInN0YW5kYXJkLmZyYW1lbGluZXMgPSAlZFxuIiwK
CQkJCXN0YW5kYXJkLmZyYW1lbGluZXMpOwoJCQlzdGFuZGFyZC5pbmRleCsrOwoJCX0KCX0KCiNp
ZiAwCgkqY3VyX3N0ZCA9IFY0TDJfU1REX1BBTDsKCglpZiAoLTEgPT0gaW9jdGwoZmRDYXB0dXJl
LCBWSURJT0NfU19TVEQsIGN1cl9zdGQpKSB7CgkJcGVycm9yKCJzZXRfZGF0YV9mb3JtYXQ6aW9j
dGw6VklESU9DX1NfU1REXG4iKTsKCQlyZXR1cm4gLTE7Cgl9CgojZW5kaWYKCWlmICh2cGZlX2lu
cHV0IDwgMikgewoKCQlpZiAoLTEgPT0gaW9jdGwoZmRDYXB0dXJlLCBWSURJT0NfUVVFUllTVEQs
IGN1cl9zdGQpKSB7CgkJCXBlcnJvcigic2V0X2RhdGFfZm9ybWF0OmlvY3RsOlZJRElPQ19RVUVS
WVNURDpcbiIpOwoJCQlyZXR1cm4gLTE7CgkJfQoKCQlpZiAoKmN1cl9zdGQgJiBWNEwyX1NURF9O
VFNDKQoJCQlwcmludGYoIklucHV0IHZpZGVvIHN0YW5kYXJkIGlzIE5UU0MuXG4iKTsKCQllbHNl
IGlmICgqY3VyX3N0ZCAmIFY0TDJfU1REX1BBTCkKCQkJcHJpbnRmKCJJbnB1dCB2aWRlbyBzdGFu
ZGFyZCBpcyBQQUwuXG4iKTsKCQllbHNlIGlmICgqY3VyX3N0ZCAmIFY0TDJfU1REX1BBTF9NKQoJ
CQlwcmludGYoIklucHV0IHZpZGVvIHN0YW5kYXJkIGlzIFBBTC1NLlxuIik7CgkJZWxzZSBpZiAo
KmN1cl9zdGQgJiBWNEwyX1NURF9QQUxfTikKCQkJcHJpbnRmKCJJbnB1dCB2aWRlbyBzdGFuZGFy
ZCBpcyBQQUwtTi5cbiIpOwoJCWVsc2UgaWYgKCpjdXJfc3RkICYgVjRMMl9TVERfU0VDQU0pCgkJ
CXByaW50ZigiSW5wdXQgdmlkZW8gc3RhbmRhcmQgaXMgU0VDQU0uXG4iKTsKCQllbHNlIGlmICgq
Y3VyX3N0ZCAmIFY0TDJfU1REX1BBTF82MCkKCQkJcHJpbnRmKCJJbnB1dCB2aWRlbyBzdGFuZGFy
ZCB0byBQQUw2MC5cbiIpOwoJCWVsc2UgCgkJCXJldHVybiAtMTsKCgkJLyogU2V0IHRoZSBzdGFu
ZGFyZCB0byBkZXRlY3RlZCBvbmUgKi8KCQlpZiAoKCpjdXJfc3RkICYgVjRMMl9TVERfTlRTQykg
JiYgKGlucHV0X3N0ZCA9PSAwKSkKCQkJcHJpbnRmKCJTZXR0aW5nIHN0YW5kYXJkIHRvIE5UU0Nc
biIpOyAKCQllbHNlIGlmICgoKmN1cl9zdGQgJiBWNEwyX1NURF9QQUwpICYmIChpbnB1dF9zdGQg
PT0gMSkpIAoJCQlwcmludGYoIlNldHRpbmcgc3RhbmRhcmQgdG8gUEFMXG4iKTsgCgkJZWxzZSB7
CgkJCWlmICghaW5wdXRfc3RkKQoJCQkJcHJpbnRmKCJGYWlsIHRvIGRldGVjdCB0aGUgTlRTQyBz
dGFuZGFyZCBhdCB0aGUgaW5wdXRcbiIpOwoJCQllbHNlIAoJCQkJcHJpbnRmKCJGYWlsIHRvIGRl
dGVjdCB0aGUgUEFMIHN0YW5kYXJkIGF0IHRoZSBpbnB1dFxuIik7CgkJCXJldHVybiAtMTsKCQl9
CgoJCWlmICgtMSA9PSBpb2N0bChmZENhcHR1cmUsIFZJRElPQ19TX1NURCwgY3VyX3N0ZCkpIHsK
CQkJcGVycm9yKCJzZXRfZGF0YV9mb3JtYXQ6aW9jdGw6VklESU9DX1NfU1REOlxuIik7CgkJCXJl
dHVybiAtMTsKCQl9CgoJfSBlbHNlIGlmICh2cGZlX2lucHV0ID09IDMpIHsKCQlpZiAoaW5wdXRf
c3RkID09IDApCgkJCSpjdXJfc3RkID0gVjRMMl9TVERfNzIwUF82MDsKCQllbHNlCgkJCSpjdXJf
c3RkID0gVjRMMl9TVERfMTA4MElfNjA7CgkJcHJpbnRmKCJTZXR0aW5nIHN0YW5kYXJkLCBzdGRf
aWQgLSAlbGx4XG4iLCpjdXJfc3RkKTsgCgoJCWlmICgtMSA9PSBpb2N0bChmZENhcHR1cmUsIFZJ
RElPQ19TX1NURCwgY3VyX3N0ZCkpIHsKCQkJcGVycm9yKCJzZXRfZGF0YV9mb3JtYXQ6aW9jdGw6
VklESU9DX1NfU1REOlxuIik7CgkJCXJldHVybiAtMTsKCQl9CgoJCWlmICgtMSA9PSBpb2N0bChm
ZENhcHR1cmUsIFZJRElPQ19RVUVSWVNURCwgY3VyX3N0ZCkpIHsKCQkJcGVycm9yKCJzZXRfZGF0
YV9mb3JtYXQ6aW9jdGw6VklESU9DX1FVRVJZU1REOlxuIik7CgkJCXJldHVybiAtMTsKCQl9CgoJ
CWlmICgqY3VyX3N0ZCAmIFY0TDJfU1REXzcyMFBfNjApCgkJCXByaW50ZigiSW5wdXQgdmlkZW8g
c3RhbmRhcmQgaXMgNzIwUC02MC5cbiIpOwoJCWVsc2UgaWYgKCpjdXJfc3RkICYgVjRMMl9TVERf
MTA4MElfNjApCgkJCXByaW50ZigiSW5wdXQgdmlkZW8gc3RhbmRhcmQgaXMgMTA4MEktNjAuXG4i
KTsKCQllbHNlIAoJCQlyZXR1cm4gLTE7Cgl9CgoJLyogc2VsZWN0IGNyb3BwaW5nIGFzIGRlYXVs
dCByZWN0YW5nbGUgKi8KCWNyb3BjYXAudHlwZSA9IFY0TDJfQlVGX1RZUEVfVklERU9fQ0FQVFVS
RTsKCglpZiAoLTEgPT0gaW9jdGwoZmRDYXB0dXJlLCBWSURJT0NfQ1JPUENBUCwgJmNyb3BjYXAp
KSB7CgkJcHJpbnRmKCJJbml0RGV2aWNlOmlvY3RsOlZJRElPQ19DUk9QQ0FQXG4iKTsKCQkvKiBp
Z25vcmUgZXJyb3IgKi8KCX0KCglwcmludGYoIkRlZmF1bHQgY3JvcCBjYXBiaWxpdHkgYm91bmRz
IC0gJWQgJWQgJWQgJWQiCgkgICAgICAgIiA7IGRlZmF1bHQgLSAlZCAlZCAlZCAlZCBcbiIsCgkg
ICAgICAgY3JvcGNhcC5ib3VuZHMubGVmdCwgY3JvcGNhcC5ib3VuZHMudG9wLAoJICAgICAgIGNy
b3BjYXAuYm91bmRzLndpZHRoLCBjcm9wY2FwLmJvdW5kcy5oZWlnaHQsCgkgICAgICAgY3JvcGNh
cC5kZWZyZWN0LmxlZnQsIGNyb3BjYXAuZGVmcmVjdC50b3AsCgkgICAgICAgY3JvcGNhcC5kZWZy
ZWN0LndpZHRoLCBjcm9wY2FwLmRlZnJlY3QuaGVpZ2h0KTsKCXByaW50Zigic2V0X2RhdGFfZm9y
bWF0OnNldHRpbmcgZGF0YSBmb3JtYXRcbiIpOwoKCUNMRUFSKGZtdF9kZXNjKTsKCWZtdF9kZXNj
LnR5cGUgPSBWNEwyX0JVRl9UWVBFX1ZJREVPX0NBUFRVUkU7CglwcmludGYoIkF2YWlsYWJsZSBp
bWFnZSBmb3JtYXRzIGF0IHRoZSBjYXB0dXJlIGRyaXZlciA6LVxuIik7Cgl3aGlsZSAoMCA9PSBp
b2N0bChmZENhcHR1cmUsIFZJRElPQ19FTlVNX0ZNVCwgJmZtdF9kZXNjKSkgewoJCXByaW50Zigi
Zm10X2Rlc2MuaW5kZXggPSAlZFxuIiwgZm10X2Rlc2MuaW5kZXgpOwoJCXByaW50ZigiZm10X2Rl
c2MudHlwZSA9ICVkXG4iLCBmbXRfZGVzYy50eXBlKTsKCQlwcmludGYoImZtdF9kZXNjLmRlc2Ny
aXB0aW9uID0gJXNcbiIsIGZtdF9kZXNjLmRlc2NyaXB0aW9uKTsKCQlwcmludGYoImZtdF9kZXNj
LnBpeGVsZm9ybWF0ID0gJXhcbiIsIGZtdF9kZXNjLnBpeGVsZm9ybWF0KTsKCQlmbXRfZGVzYy5p
bmRleCsrOwoJfQoJCgkvKiBUcnkgZm9ybWF0IHdpdGggbWluaW11bSBhbmQgbWF4aW11bSB2YWx1
ZXMgKi8KCUNMRUFSKGZtdCk7CglmbXQudHlwZSA9IFY0TDJfQlVGX1RZUEVfVklERU9fQ0FQVFVS
RTsKCWZtdC5mbXQucGl4LndpZHRoID0gMTsKCWZtdC5mbXQucGl4LmhlaWdodCA9IDE7CglpZiAo
dnBmZV9pbnB1dCA9PSAyKSB7CgkJZm10LmZtdC5waXgucGl4ZWxmb3JtYXQgPSBWNEwyX1BJWF9G
TVRfU0JHR1I4OwoJCWZtdC5mbXQucGl4LmZpZWxkID0gVjRMMl9GSUVMRF9BTlk7Cgl9IGVsc2Ug
ewoJCWZtdC5mbXQucGl4LmZpZWxkID0gVjRMMl9GSUVMRF9BTlk7CgkJZm10LmZtdC5waXgucGl4
ZWxmb3JtYXQgPSBWNEwyX1BJWF9GTVRfVVlWWTsKCX0KCXByaW50ZigiKioqKioqKlRSWV9GTVQg
KE1pbiByZXNvbHV0aW9uKSB2YWx1ZXMgYmVmb3JlIGNhbGxpbmcgaW9jdGwqKioqKioqKioqKioq
XG4iKTsKCXByaW50ZigiZm10LmZtdC5waXgud2lkdGggPSAlZFxuIiwgZm10LmZtdC5waXgud2lk
dGgpOwoJcHJpbnRmKCJmbXQuZm10LnBpeC5oZWlnaHQgPSAlZFxuIiwgZm10LmZtdC5waXguaGVp
Z2h0KTsKCXByaW50ZigiZm10LmZtdC5waXguZmllbGQ9ICVkXG4iLCBmbXQuZm10LnBpeC5maWVs
ZCk7CglwcmludGYoImZtdC5mbXQucGl4LmJ5dGVzcGVybGluZSA9ICVkXG4iLCBmbXQuZm10LnBp
eC5ieXRlc3BlcmxpbmUpOwoJcHJpbnRmKCJmbXQuZm10LnBpeC5zaXplaW1hZ2UgPSAlZFxuIiwg
Zm10LmZtdC5waXguc2l6ZWltYWdlKTsKCWlmICgtMSA9PSBpb2N0bChmZENhcHR1cmUsIFZJRElP
Q19UUllfRk1ULCAmZm10KSkKCQlwcmludGYoIkVycm9yOnNldF9kYXRhX2Zvcm1hdDppb2N0bDpW
SURJT0NfVFJZX0ZNVFxuIik7CgoJcHJpbnRmKCIqKioqKioqVFJZX0ZNVCB2YWx1ZXMgYWZ0ZXIg
Y2FsbGluZyBpb2N0bCoqKioqKioqKioqKipcbiIpOwoJcHJpbnRmKCJmbXQuZm10LnBpeC53aWR0
aCA9ICVkXG4iLCBmbXQuZm10LnBpeC53aWR0aCk7CglwcmludGYoImZtdC5mbXQucGl4LmhlaWdo
dCA9ICVkXG4iLCBmbXQuZm10LnBpeC5oZWlnaHQpOwoJcHJpbnRmKCJmbXQuZm10LnBpeC5maWVs
ZD0gJWRcbiIsIGZtdC5mbXQucGl4LmZpZWxkKTsKCXByaW50ZigiZm10LmZtdC5waXguYnl0ZXNw
ZXJsaW5lID0gJWRcbiIsIGZtdC5mbXQucGl4LmJ5dGVzcGVybGluZSk7CglwcmludGYoImZtdC5m
bXQucGl4LnNpemVpbWFnZSA9ICVkXG4iLCBmbXQuZm10LnBpeC5zaXplaW1hZ2UpOwoJCglDTEVB
UihmbXQpOwoJZm10LnR5cGUgPSBWNEwyX0JVRl9UWVBFX1ZJREVPX0NBUFRVUkU7CglmbXQuZm10
LnBpeC53aWR0aCA9ICgxIDw8IDE1KTsKCWZtdC5mbXQucGl4LmhlaWdodCA9ICgxIDw8IDE1KTsK
CWlmICh2cGZlX2lucHV0ID09IDIpIHsKCQlmbXQuZm10LnBpeC5waXhlbGZvcm1hdCA9IFY0TDJf
UElYX0ZNVF9TQkdHUjg7CgkJZm10LmZtdC5waXguZmllbGQgPSBWNEwyX0ZJRUxEX0FOWTsKCX0g
ZWxzZSB7CgkJZm10LmZtdC5waXguZmllbGQgPSBWNEwyX0ZJRUxEX0FOWTsKCQlmbXQuZm10LnBp
eC5waXhlbGZvcm1hdCA9IFY0TDJfUElYX0ZNVF9VWVZZOwoJfQoJcHJpbnRmKCIqKioqKioqVFJZ
X0ZNVCAoTWF4IHJlc29sdXRpb24pIHZhbHVlcyBiZWZvcmUgY2FsbGluZyBpb2N0bCoqKioqKioq
KioqKipcbiIpOwoJcHJpbnRmKCJmbXQuZm10LnBpeC53aWR0aCA9ICVkXG4iLCBmbXQuZm10LnBp
eC53aWR0aCk7CglwcmludGYoImZtdC5mbXQucGl4LmhlaWdodCA9ICVkXG4iLCBmbXQuZm10LnBp
eC5oZWlnaHQpOwoJcHJpbnRmKCJmbXQuZm10LnBpeC5maWVsZD0gJWRcbiIsIGZtdC5mbXQucGl4
LmZpZWxkKTsKCXByaW50ZigiZm10LmZtdC5waXguYnl0ZXNwZXJsaW5lID0gJWRcbiIsIGZtdC5m
bXQucGl4LmJ5dGVzcGVybGluZSk7CglwcmludGYoImZtdC5mbXQucGl4LnNpemVpbWFnZSA9ICVk
XG4iLCBmbXQuZm10LnBpeC5zaXplaW1hZ2UpOwoJaWYgKC0xID09IGlvY3RsKGZkQ2FwdHVyZSwg
VklESU9DX1RSWV9GTVQsICZmbXQpKQoJCXByaW50ZigiRXJyb3I6c2V0X2RhdGFfZm9ybWF0Omlv
Y3RsOlZJRElPQ19UUllfRk1UXG4iKTsKCglwcmludGYoIioqKioqKipUUllfRk1UIHZhbHVlcyBh
ZnRlciBjYWxsaW5nIGlvY3RsKioqKioqKioqKioqKlxuIik7CglwcmludGYoImZtdC5mbXQucGl4
LndpZHRoID0gJWRcbiIsIGZtdC5mbXQucGl4LndpZHRoKTsKCXByaW50ZigiZm10LmZtdC5waXgu
aGVpZ2h0ID0gJWRcbiIsIGZtdC5mbXQucGl4LmhlaWdodCk7CglwcmludGYoImZtdC5mbXQucGl4
LmZpZWxkPSAlZFxuIiwgZm10LmZtdC5waXguZmllbGQpOwoJcHJpbnRmKCJmbXQuZm10LnBpeC5i
eXRlc3BlcmxpbmUgPSAlZFxuIiwgZm10LmZtdC5waXguYnl0ZXNwZXJsaW5lKTsKCXByaW50Zigi
Zm10LmZtdC5waXguc2l6ZWltYWdlID0gJWRcbiIsIGZtdC5mbXQucGl4LnNpemVpbWFnZSk7CgoJ
aWYgKHZwZmVfaW5wdXQgPT0gMikgewoJCWlmKGlucHV0X3N0ZCA9PSAwKQoJCXsKCQkJZm10LmZt
dC5waXgud2lkdGggPSA2NDA7CgkJCWZtdC5mbXQucGl4LmhlaWdodCA9IDQ4MDsKCQl9CgkJZWxz
ZSBpZihpbnB1dF9zdGQgPT0gMSkKCQl7CgkJCWZtdC5mbXQucGl4LndpZHRoID0gNzM2OwoJCQlm
bXQuZm10LnBpeC5oZWlnaHQgPSA0ODA7CgkJfQoJCWVsc2UgaWYoaW5wdXRfc3RkID09IDIpCgkJ
ewoJCQlmbXQuZm10LnBpeC53aWR0aCA9IDczNjsKCQkJZm10LmZtdC5waXguaGVpZ2h0ID0gNTc2
OwoJCX0KCQllbHNlIGlmKGlucHV0X3N0ZCA9PSAzKQoJCXsKCQkJZm10LmZtdC5waXgud2lkdGgg
PSAxMjgwOwoJCQlmbXQuZm10LnBpeC5oZWlnaHQgPSA3MjA7CgkJfQoJCWVsc2UgaWYoaW5wdXRf
c3RkID09IDQpCgkJewoJCQlmbXQuZm10LnBpeC53aWR0aCA9IDE5MjA7CgkJCWZtdC5mbXQucGl4
LmhlaWdodCA9IDEwODA7CgkJfQoJCWZtdC5mbXQucGl4LnBpeGVsZm9ybWF0ID0gVjRMMl9QSVhf
Rk1UX1NCR0dSODsKCQlmbXQuZm10LnBpeC5maWVsZCA9IFY0TDJfRklFTERfTk9ORTsKCX0gZWxz
ZSBpZiAodnBmZV9pbnB1dCA9PSAzKSB7CgkJZm10LmZtdC5waXgucGl4ZWxmb3JtYXQgPSBWNEwy
X1BJWF9GTVRfVVlWWTsKCQlpZihpbnB1dF9zdGQgPT0gMCkKCQl7CgkJCWZtdC5mbXQucGl4Lndp
ZHRoID0gMTI4MDsKCQkJZm10LmZtdC5waXguaGVpZ2h0ID0gNzIwOwoJCQlmbXQuZm10LnBpeC5m
aWVsZCA9IFY0TDJfRklFTERfTk9ORTsKCQl9CgkJZWxzZSBpZihpbnB1dF9zdGQgPT0gMSkKCQl7
CgkJCWZtdC5mbXQucGl4LndpZHRoID0gMTkyMDsKCQkJZm10LmZtdC5waXguaGVpZ2h0ID0gMTA4
MDsKCQkJZm10LmZtdC5waXguZmllbGQgPSBWNEwyX0ZJRUxEX0lOVEVSTEFDRUQ7CgkJfQoJfSBl
bHNlIHsKCQlpZiAoY3JvcF9lbiA9PSAxKQoJCXsKCQkJZm10LmZtdC5waXgud2lkdGggPSBjcl93
aWR0aDsKCQkJZm10LmZtdC5waXguaGVpZ2h0ID0gY3JfaGVpZ2h0OwoJCX0JCgkJZWxzZSBpZiAo
KmN1cl9zdGQgJiBWNEwyX1NURF9OVFNDKSB7CgkJCWZtdC5mbXQucGl4LndpZHRoID0gV0lEVEhf
TlRTQzsKCQkJZm10LmZtdC5waXguaGVpZ2h0ID0gSEVJR0hUX05UU0M7CgkJCWNyX3dpZHRoID0g
V0lEVEhfTlRTQzsKCQkJY3JfaGVpZ2h0ID0gSEVJR0hUX05UU0M7CgkJfSBlbHNlIHsKCQkJZm10
LmZtdC5waXgud2lkdGggPSBXSURUSF9QQUw7CgkJCWZtdC5mbXQucGl4LmhlaWdodCA9IEhFSUdI
VF9QQUw7CgkJCWNyX3dpZHRoID0gV0lEVEhfUEFMOwoJCQljcl9oZWlnaHQgPSBIRUlHSFRfUEFM
OwoJCX0KCQkKCQlmbXQuZm10LnBpeC5waXhlbGZvcm1hdCA9IFY0TDJfUElYX0ZNVF9VWVZZOwoJ
CWlmIChmaWVsZCkKCQkJZm10LmZtdC5waXguZmllbGQgPSBWNEwyX0ZJRUxEX1NFUV9UQjsKCQll
bHNlCgkJCWZtdC5mbXQucGl4LmZpZWxkID0gVjRMMl9GSUVMRF9JTlRFUkxBQ0VEOwoJfQoKCXBy
aW50ZigidGhlIGZpbGVkID0gJWQgXG4iLCBmbXQuZm10LnBpeC5maWVsZCk7CgkKCSNpZiAwCglm
bXQuZm10LnBpeC5maWVsZCA9IDA7CglmbXQuZm10LnBpeC5waXhlbGZvcm1hdCA9IFY0TDJfUElY
X0ZNVF9ZVVlWOwoJI2VuZGlmCgoJaWYgKC0xID09IGlvY3RsKGZkQ2FwdHVyZSwgVklESU9DX1Nf
Rk1ULCAmZm10KSkKCQlwcmludGYoInNldF9kYXRhX2Zvcm1hdDppb2N0bDpWSURJT0NfU19GTVRc
biIpOwoKCWlmICgtMSA9PSBpb2N0bChmZENhcHR1cmUsIFZJRElPQ19HX0ZNVCwgJmZtdCkpCgkJ
cHJpbnRmKCJzZXRfZGF0YV9mb3JtYXQ6aW9jdGw6VklESU9DX1FVRVJZU1REOlxuIik7CgoJaWYo
Y3JvcF9lbiA9PSAxKQoJewoJCWNyb3AudHlwZSA9IFY0TDJfQlVGX1RZUEVfVklERU9fQ0FQVFVS
RTsKCQljcm9wLmMud2lkdGg9IGNyX3dpZHRoOwoJCWNyb3AuYy5oZWlnaHQ9IGNyX2hlaWdodDsK
CQljcm9wLmMudG9wICA9IGNyX3RvcDsKCQljcm9wLmMubGVmdCA9IGNyX2xlZnQ7CgkJaWYoLTEg
PT0gaW9jdGwoZmRDYXB0dXJlLCBWSURJT0NfU19DUk9QLCAmY3JvcCkpCgkJewoJCQlwZXJyb3Io
IkVycm9yIGluIHNldHRpbmcgY3JvcCBcbiIpOwoJCQlyZXR1cm4gLTE7CgkJfQoJfQoJCQoJCgoJ
bldpZHRoRmluYWwgPSBmbXQuZm10LnBpeC53aWR0aDsKCW5IZWlnaHRGaW5hbCA9IGZtdC5mbXQu
cGl4LmhlaWdodDsKCglwcmludGYoInNldF9kYXRhX2Zvcm1hdDpmaW5hbGx5IG5lZ290aWF0ZWQg
d2lkdGg6JWQgaGVpZ2h0OiVkXG4iLAoJICAgICAgIG5XaWR0aEZpbmFsLCBuSGVpZ2h0RmluYWwp
OwoKCS8qIGNoZWNraW5nIHdoYXQgaXMgZmluYWxseSBuZWdvdGlhdGVkICovCgltaW4gPSBmbXQu
Zm10LnBpeC53aWR0aCAqIDI7CglpZiAoZm10LmZtdC5waXguYnl0ZXNwZXJsaW5lIDwgbWluKSB7
CgkJcHJpbnRmCgkJICAgICgic2V0X2RhdGFfZm9ybWF0OmRyaXZlciByZXBvcnRzIGJ5dGVzX3Bl
cl9saW5lOiVkKGJ1ZylcbiIsCgkJICAgICBmbXQuZm10LnBpeC5ieXRlc3BlcmxpbmUpOwoJCS8q
Y29ycmVjdCBpdCAqLwoJCWZtdC5mbXQucGl4LmJ5dGVzcGVybGluZSA9IG1pbjsKCX0gZWxzZSB7
CgkJcHJpbnRmCgkJICAgICgic2V0X2RhdGFfZm9ybWF0OmRyaXZlciByZXBvcnRzIGJ5dGVzX3Bl
cl9saW5lOiVkXG4iLAoJCSAgICAgZm10LmZtdC5waXguYnl0ZXNwZXJsaW5lKTsKCX0KCXNyY19s
aW5lX2xlbiA9IGZtdC5mbXQucGl4LmJ5dGVzcGVybGluZTsKCW1pbiA9IGZtdC5mbXQucGl4LmJ5
dGVzcGVybGluZSAqIGZtdC5mbXQucGl4LmhlaWdodDsKCWlmIChmbXQuZm10LnBpeC5zaXplaW1h
Z2UgPCBtaW4pIHsKCQlwcmludGYoInNldF9kYXRhX2Zvcm1hdDpkcml2ZXIgcmVwb3J0cyBzaXpl
OiVkKGJ1ZylcbiIsCgkJICAgICAgIGZtdC5mbXQucGl4LnNpemVpbWFnZSk7CgoJCS8qY29ycmVj
dCBpdCAqLwoJCWZtdC5mbXQucGl4LnNpemVpbWFnZSA9IG1pbjsKCX0gZWxzZSB7CgkJcHJpbnRm
KCJzZXRfZGF0YV9mb3JtYXQ6ZHJpdmVyIHJlcG9ydHMgc2l6ZTolZFxuIiwKCQkgICAgICAgZm10
LmZtdC5waXguc2l6ZWltYWdlKTsKCX0KCglwcmludGYoInNldF9kYXRhX2Zvcm1hdDpGaW5hbGx5
IG5lZ290aWF0ZWQgd2lkdGg6JWQgaGVpZ2h0OiVkXG4iLAoJICAgICAgIG5XaWR0aEZpbmFsLCBu
SGVpZ2h0RmluYWwpOwoKCXJldHVybiAwOwp9CgovKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqLwpzdGF0
aWMgaW50IGluaXRfY2FwdHVyZV9idWZmZXJzKHZvaWQpCnsKCXN0cnVjdCB2NGwyX3JlcXVlc3Ri
dWZmZXJzIHJlcTsKCWludCBuSW5kZXggPSAwOwoKCUNMRUFSKHJlcSk7CglyZXEuY291bnQgPSBN
SU5fQlVGRkVSUzsKCXJlcS50eXBlID0gVjRMMl9CVUZfVFlQRV9WSURFT19DQVBUVVJFOwoJcmVx
Lm1lbW9yeSA9IFY0TDJfTUVNT1JZX01NQVA7CgoJaWYgKC0xID09IGlvY3RsKGZkQ2FwdHVyZSwg
VklESU9DX1JFUUJVRlMsICZyZXEpKSB7CgkJcHJpbnRmKCJpbml0X2NhcHR1cmVfYnVmZmVyczpp
b2N0bDpWSURJT0NfUkVRQlVGU1xuIik7CgkJcmV0dXJuIC0xOwoJfQoKCWlmIChyZXEuY291bnQg
PCBNSU5fQlVGRkVSUykgewoJCXByaW50ZigiaW5pdF9jYXB0dXJlX2J1ZmZlcnMgb25seToiCgkJ
ICAgICAgICIlZCBidWZmZXJzIGF2aWxhYmxlLCBjYW4ndCBwcm9jZWVkXG4iLCByZXEuY291bnQp
OwoJCXJldHVybiAtMTsKCX0KCgluQnVmZmVycyA9IHJlcS5jb3VudDsKCXByaW50ZigiZGV2aWNl
IGJ1ZmZlcnM6JWRcbiIsIHJlcS5jb3VudCk7CglidWZmZXJzID0gKHN0cnVjdCBidWZmZXIgKilj
YWxsb2MocmVxLmNvdW50LCBzaXplb2Yoc3RydWN0IGJ1ZmZlcikpOwoJaWYgKCFidWZmZXJzKSB7
CgkJcHJpbnRmKCJpbml0X2NhcHR1cmVfYnVmZmVyczpjYWxsb2M6XG4iKTsKCQlyZXR1cm4gLTE7
Cgl9CgoJZm9yIChuSW5kZXggPSAwOyBuSW5kZXggPCByZXEuY291bnQ7ICsrbkluZGV4KSB7CgkJ
c3RydWN0IHY0bDJfYnVmZmVyIGJ1ZjsKCQlDTEVBUihidWYpOwoJCWJ1Zi50eXBlID0gVjRMMl9C
VUZfVFlQRV9WSURFT19DQVBUVVJFOwoJCWJ1Zi5tZW1vcnkgPSBWNEwyX01FTU9SWV9NTUFQOwoJ
CWJ1Zi5pbmRleCA9IG5JbmRleDsKCgkJaWYgKC0xID09IGlvY3RsKGZkQ2FwdHVyZSwgVklESU9D
X1FVRVJZQlVGLCAmYnVmKSkgewoJCQlwcmludGYoImluaXRfY2FwdHVyZV9idWZmZXJzOlZJRElP
Q19RVUVSWUJVRjpcblxuIik7CgkJCXJldHVybiAtMTsKCQl9CgoJCWJ1ZmZlcnNbbkluZGV4XS5s
ZW5ndGggPSBidWYubGVuZ3RoOwoJCWJ1ZmZlcnNbbkluZGV4XS5zdGFydCA9CgkJICAgIG1tYXAo
TlVMTCwgYnVmLmxlbmd0aCwgUFJPVF9SRUFEIHwgUFJPVF9XUklURSwKCQkJIE1BUF9TSEFSRUQs
IGZkQ2FwdHVyZSwgYnVmLm0ub2Zmc2V0KTsKCgkJcHJpbnRmKCJidWZmZXI6JWQgcGh5OiV4IG1t
YXA6JXAgbGVuZ3RoOiVkXG4iLCBidWYuaW5kZXgsCgkJICAgICAgIGJ1Zi5tLm9mZnNldCwgYnVm
ZmVyc1tuSW5kZXhdLnN0YXJ0LCBidWYubGVuZ3RoKTsKCgkJaWYgKE1BUF9GQUlMRUQgPT0gYnVm
ZmVyc1tuSW5kZXhdLnN0YXJ0KSB7CgkJCXByaW50ZigiaW5pdF9jYXB0dXJlX2J1ZmZlcnM6bW1h
cDpcbiIpOwoJCQlyZXR1cm4gLTE7CgkJfQoJfQoJcmV0dXJuIDA7Cn0KCi8qKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKiovCnN0YXRpYyBpbnQgc3RhcnRfc3RyZWFtaW5nKHZvaWQpCnsKCWludCBpID0gMDsK
CWVudW0gdjRsMl9idWZfdHlwZSB0eXBlOwoKCWZvciAoaSA9IDA7IGkgPCBuQnVmZmVyczsgaSsr
KSB7CgkJc3RydWN0IHY0bDJfYnVmZmVyIGJ1ZjsKCQlDTEVBUihidWYpOwoJCWJ1Zi50eXBlID0g
VjRMMl9CVUZfVFlQRV9WSURFT19DQVBUVVJFOwoJCWJ1Zi5tZW1vcnkgPSBWNEwyX01FTU9SWV9N
TUFQOwoJCWJ1Zi5pbmRleCA9IGk7CgkJcHJpbnRmKCJRdWVpbmcgYnVmZmVyOiVkXG4iLCBpKTsK
CgkJaWYgKC0xID09IGlvY3RsKGZkQ2FwdHVyZSwgVklESU9DX1FCVUYsICZidWYpKQoJCQlwcmlu
dGYoInN0YXJ0X3N0cmVhbWluZzppb2N0bDpWSURJT0NfUUJVRjpcbiIpOwoJfQoJLyogYWxsIGRv
bmUgLCBnZXQgc2V0IGdvICovCgl0eXBlID0gVjRMMl9CVUZfVFlQRV9WSURFT19DQVBUVVJFOwoJ
aWYgKC0xID09IGlvY3RsKGZkQ2FwdHVyZSwgVklESU9DX1NUUkVBTU9OLCAmdHlwZSkpCgkJcHJp
bnRmKCJzdGFydF9zdHJlYW1pbmc6aW9jdGw6VklESU9DX1NUUkVBTU9OOlxuIik7CgoJcmV0dXJu
IDA7Cn0KCi8qKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKiovCnN0YXRpYyBpbnQgc3RhcnRfZGlzcGxheShp
bnQgZmQsIGludCBpbmRleCwgaW50IGZsYWcpCnsKCWludCByZXQ7CglzdHJ1Y3QgdjRsMl9idWZm
ZXIgYnVmOwoJZW51bSB2NGwyX2J1Zl90eXBlIHR5cGU7CgoJYnplcm8oJmJ1Ziwgc2l6ZW9mKGJ1
ZikpOwoJLyoKCSAqICAgICAgUXVldWUgYWxsIHRoZSBidWZmZXJzIGZvciB0aGUgaW5pdGlhbCBy
dW5uaW5nCgkgKi8KCXByaW50ZigiNi4gVGVzdCBlbnF1ZXVpbmcgb2YgYnVmZmVycyAtICIpOwoJ
YnVmLnR5cGUgPSBWNEwyX0JVRl9UWVBFX1ZJREVPX09VVFBVVDsKCWJ1Zi5tZW1vcnkgPSBWNEwy
X01FTU9SWV9VU0VSUFRSOwoJYnVmLmluZGV4ID0gaW5kZXg7CglidWYubGVuZ3RoID0gZGlzcGxh
eV9pbWFnZV9zaXplOwoJYnVmLm0udXNlcnB0ciA9ICh1bnNpZ25lZCBsb25nKWJ1ZmZlcnNbaW5k
ZXhdLnN0YXJ0OwoJcmV0ID0gaW9jdGwoZmQsIFZJRElPQ19RQlVGLCAmYnVmKTsKCWlmIChyZXQg
PCAwKSB7CgkJcHJpbnRmKCJmZCA9ICVkXG4iLCBmZCk7CgkJcHJpbnRmKCJcblx0RXJyb3I6IEVu
cXVldWluZyBidWZmZXJbJWRdIGZhaWxlZDogVklEMSIsCgkJICAgICAgIGluZGV4KTsKCQlyZXR1
cm4gLTE7Cgl9CgoJcHJpbnRmKCJkb25lXG4iKTsKCglpZiAoZmxhZykgewoJCXByaW50ZigiNy4g
VGVzdCBTVFJFQU1fT05cbiIpOwoJCXR5cGUgPSBWNEwyX0JVRl9UWVBFX1ZJREVPX09VVFBVVDsK
CQlyZXQgPSBpb2N0bChmZCwgVklESU9DX1NUUkVBTU9OLCAmdHlwZSk7CgkJaWYgKHJldCA8IDAp
IHsKCQkJcGVycm9yKCJWSURJT0NfU1RSRUFNT05cbiIpOwoJCQlyZXR1cm4gLTE7CgkJfQoJfQoK
CXJldHVybiAwOwp9CgovKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqLwpzdGF0aWMgaW50IGluaXRfdmlk
MV9kZXZpY2UodjRsMl9zdGRfaWQgY3VyX3N0ZCkKewoJaW50IG1vZGUgPSBPX1JEV1I7CglpbnQg
aSA9IDAsIHJldCA9IDA7CgoJc3RydWN0IHY0bDJfZm9ybWF0IGZtdCwgc2V0Zm10OwoJc3RydWN0
IHY0bDJfZm10ZGVzYyBmb3JtYXQ7CglzdHJ1Y3QgdjRsMl9jYXBhYmlsaXR5IGNhcGFiaWxpdHk7
CgoJLyogb3BlbiBvc2QwLCBvc2QxIGRldmljZXMgYW5kIGRpc2FibGUgKi8KCWZkX29zZDAgPSBv
cGVuKE9TRDBfREVWSUNFLCBtb2RlKTsKCWlvY3RsKGZkX29zZDAsIEZCSU9CTEFOSywgMSk7CgoJ
ZmRfb3NkMSA9IG9wZW4oT1NEMV9ERVZJQ0UsIG1vZGUpOwoJaW9jdGwoZmRfb3NkMSwgRkJJT0JM
QU5LLCAxKTsKCgkvKgoJICogMS4gT3BlbiBkaXNwbGF5IGNoYW5uZWwKCSAqLwoJcHJpbnRmKCIx
LiBPcGVuaW5nIFZJRDEgZGV2aWNlXG4iKTsKCWZkX3ZpZDEgPSBvcGVuKFZJRDFfREVWSUNFLCBt
b2RlKTsKCWlmICgtMSA9PSBmZF92aWQxKSB7CgkJcHJpbnRmKCJmYWlsZWQgdG8gb3BlbiBWSUQx
IGRpc3BsYXkgZGV2aWNlXG4iKTsKCQlyZXR1cm4gLTE7Cgl9CglwcmludGYoImRvbmVcbiIpOwoK
CS8qIFRlc3RpbmcgSU9DVExzICovCglyZXQgPSBpb2N0bChmZF92aWQxLCBWSURJT0NfUVVFUllD
QVAsICZjYXBhYmlsaXR5KTsKCWlmIChyZXQgPCAwKSB7CgkJcHJpbnRmKCJGQUlMRUQ6IFFVRVJZ
Q0FQXG4iKTsKCQlyZXR1cm4gLTE7Cgl9CglwcmludGYoImZkID0gJWRcbiIsIGZkX3ZpZDEpOwoJ
aWYgKGNhcGFiaWxpdHkuY2FwYWJpbGl0aWVzICYgVjRMMl9DQVBfVklERU9fT1VUUFVUKQoJCXBy
aW50ZigiRGlzcGxheSBjYXBhYmlsaXR5IGlzIHN1cHBvcnRlZFxuIik7CglpZiAoY2FwYWJpbGl0
eS5jYXBhYmlsaXRpZXMgJiBWNEwyX0NBUF9TVFJFQU1JTkcpCgkJcHJpbnRmKCJTdHJlYW1pbmcg
aXMgc3VwcG9ydGVkXG4iKTsKCgl3aGlsZSAoMSkgewoJCWZvcm1hdC5pbmRleCA9IGk7CgkJZm9y
bWF0LnR5cGUgPSBWNEwyX0JVRl9UWVBFX1ZJREVPX09VVFBVVDsKCQlyZXQgPSBpb2N0bChmZF92
aWQxLCBWSURJT0NfRU5VTV9GTVQsICZmb3JtYXQpOwoJCWlmIChyZXQgPCAwKQoJCQlicmVhazsK
CQlwcmludGYoImRlc2NyaXB0aW9uID0gJXNcbiIsIGZvcm1hdC5kZXNjcmlwdGlvbik7CgkJaWYg
KGZvcm1hdC50eXBlID09IFY0TDJfQlVGX1RZUEVfVklERU9fT1VUUFVUKQoJCQlwcmludGYoIlZp
ZGVvIERpc3BsYXkgdHlwZVxuIik7CgkJaWYgKGZvcm1hdC5waXhlbGZvcm1hdCA9PSBWNEwyX1BJ
WF9GTVRfVVlWWSkKCQkJcHJpbnRmKCJWNEwyX1BJWF9GTVRfVVlWWVxuIik7CgkJaSsrOwoJfQoK
CS8qCgkgKiBOb3cgZm9yIHRoZSBidWZmZXJzLiBSZXF1ZXN0IHRoZSBudW1iZXIgb2YgYnVmZmVy
cyBuZWVkZWQKCSAqIGFuZCB0aGUga2luZCBvZiBidWZmZXJzIChVc2VyIGJ1ZmZlcnMgb3Iga2Vy
bmVsIGJ1ZmZlcnMKCSAqIGZvciBtZW1vcnkgbWFwcGluZykuCgkgKiBQbGVhc2Ugbm90ZSB0aGF0
IHRoZSByZXR1cm4gdmFsdWUgaW4gdGhlIHJlcWJ1Zi5jb3VudAoJICogbWlnaHQgYmUgbGVzc2Vy
IHRoYW4gbnVtYnVmZmVycyB1bmRlciBzb21lIGxvdyBtZW1vcnkKCSAqIGNpcmN1bXN0YW5jZXMK
CSAqLwoJcHJpbnRmKCIyLiBUZXN0IHJlcXVlc3QgZm9yIGJ1ZmZlcnNcbiIpOwoJcmVxYnVmLnR5
cGUgPSBWNEwyX0JVRl9UWVBFX1ZJREVPX09VVFBVVDsKCXJlcWJ1Zi5jb3VudCA9IG51bWJ1ZmZl
cnM7CglyZXFidWYubWVtb3J5ID0gVjRMMl9NRU1PUllfVVNFUlBUUjsKCXJldCA9IGlvY3RsKGZk
X3ZpZDEsIFZJRElPQ19SRVFCVUZTLCAmcmVxYnVmKTsKCWlmIChyZXQgPCAwKSB7CgkJcHJpbnRm
KCJcblx0RXJyb3I6IENvdWxkIG5vdCBhbGxvY2F0ZSB0aGUgYnVmZmVyczogVklEMVxuIik7CgkJ
cmV0dXJuIC0xOwoJfQoJcHJpbnRmKCJcdE51bWJlcnMgb2YgYnVmZmVycyByZXR1cm5lZCAtICVk
XG4iLCByZXFidWYuY291bnQpOwoJQ0xFQVIoc2V0Zm10KTsKCXNldGZtdC50eXBlID0gVjRMMl9C
VUZfVFlQRV9WSURFT19PVVRQVVQ7CglzZXRmbXQuZm10LnBpeC5waXhlbGZvcm1hdCA9IFY0TDJf
UElYX0ZNVF9VWVZZOwoJaWYgKGN1cl9zdGQgJiBWNEwyX1NURF9OVFNDKSB7CgkJcHJpbnRmKCJp
bml0X3ZpZDFfZGV2aWNlOnJlcXVlc3Rpbmcgd2lkdGg6JWQgaGVpZ2h0OiVkXG4iLAoJCSAgICAg
ICBXSURUSF9OVFNDLCBIRUlHSFRfTlRTQyk7CgkJc2V0Zm10LmZtdC5waXguYnl0ZXNwZXJsaW5l
ID0gV0lEVEhfTlRTQyAqIDI7CgkJc2V0Zm10LmZtdC5waXguc2l6ZWltYWdlID0KCQkgICAgc2V0
Zm10LmZtdC5waXguYnl0ZXNwZXJsaW5lICogSEVJR0hUX05UU0M7CgkJc2V0Zm10LmZtdC5waXgu
ZmllbGQgPSBWNEwyX0ZJRUxEX0lOVEVSTEFDRUQ7Cgl9IGVsc2UgaWYgKChjdXJfc3RkICYgVjRM
Ml9TVERfUEFMKSB8fAoJCShjdXJfc3RkICYgVjRMMl9TVERfUEFMX00pIHx8CgkJKGN1cl9zdGQg
JiBWNEwyX1NURF9QQUxfTikpIHsKCQlwcmludGYoImluaXRfdmlkMV9kZXZpY2U6cmVxdWVzdGlu
ZyB3aWR0aDolZCBoZWlnaHQ6JWRcbiIsCgkJICAgICAgIFdJRFRIX1BBTCwgSEVJR0hUX1BBTCk7
CgkJc2V0Zm10LmZtdC5waXguYnl0ZXNwZXJsaW5lID0gV0lEVEhfUEFMICogMjsKCQlzZXRmbXQu
Zm10LnBpeC5zaXplaW1hZ2UgPQoJCSAgICBzZXRmbXQuZm10LnBpeC5ieXRlc3BlcmxpbmUgKiBI
RUlHSFRfUEFMOwoJCXNldGZtdC5mbXQucGl4LmZpZWxkID0gVjRMMl9GSUVMRF9JTlRFUkxBQ0VE
OwoJfSBlbHNlIGlmICgoY3VyX3N0ZCAmIFY0TDJfU1REXzcyMFBfNjApIHx8CgkJICAgKGN1cl9z
dGQgJiBWNEwyX1NURF83MjBQXzUwKSkgewoJCXByaW50ZigiaW5pdF92aWQxX2RldmljZTpyZXF1
ZXN0aW5nIHdpZHRoOiVkIGhlaWdodDolZFxuIiwKCQkgICAgICAgV0lEVEhfNzIwUCwgSEVJR0hU
XzcyMFApOwoJCXNldGZtdC5mbXQucGl4LmJ5dGVzcGVybGluZSA9IFdJRFRIXzcyMFAgKiAyOwoJ
CXNldGZtdC5mbXQucGl4LnNpemVpbWFnZSA9CgkJICAgIHNldGZtdC5mbXQucGl4LmJ5dGVzcGVy
bGluZSAqIEhFSUdIVF83MjBQOwoJCXNldGZtdC5mbXQucGl4LmZpZWxkID0gVjRMMl9GSUVMRF9O
T05FOwoJfSBlbHNlIGlmICgoY3VyX3N0ZCAmIFY0TDJfU1REXzEwODBJXzYwKSB8fAoJCSAgIChj
dXJfc3RkICYgVjRMMl9TVERfMTA4MElfNTApKSB7CgkJcHJpbnRmKCJpbml0X3ZpZDFfZGV2aWNl
OnJlcXVlc3Rpbmcgd2lkdGg6JWQgaGVpZ2h0OiVkXG4iLAoJCSAgICAgICBXSURUSF8xMDgwSSwg
SEVJR0hUXzEwODBJKTsKCQlzZXRmbXQuZm10LnBpeC5ieXRlc3BlcmxpbmUgPSBXSURUSF8xMDgw
SSAqIDI7CgkJc2V0Zm10LmZtdC5waXguc2l6ZWltYWdlID0KCQkgICAgc2V0Zm10LmZtdC5waXgu
Ynl0ZXNwZXJsaW5lICogSEVJR0hUXzEwODBJOwoJCXNldGZtdC5mbXQucGl4LmZpZWxkID0gVjRM
Ml9GSUVMRF9JTlRFUkxBQ0VEOwoJfSBlbHNlIHsKCQlwcmludGYoIlRoaXMgdmlkZW8gY2Fubm90
IGJlIGRpc3BsYXllZFxuIik7CgkJY2xvc2UoZmRfdmlkMSk7CgkJcmV0dXJuIC0xOwoJfQoKCWRp
c3BsYXlfaW1hZ2Vfc2l6ZSA9IHNldGZtdC5mbXQucGl4LnNpemVpbWFnZTsKCQoJcmV0ID0gaW9j
dGwoZmRfdmlkMSwgVklESU9DX1NfRk1ULCAmc2V0Zm10KTsKCWlmIChyZXQgPCAwKSB7CgkJcGVy
cm9yKCJWSURJT0NfU19GTVRcbiIpOwoJCWNsb3NlKGZkX3ZpZDEpOwoJCXJldHVybiAtMTsKCX0g
ZWxzZQoJCXByaW50ZigiIFZJRElPQ19TX0ZNVDogUEFTU1xuIik7CgoJLyoKCSAqIEl0IGlzIG5l
Y2Vzc2FyeSBmb3IgYXBwbGljYXRpb25zIHRvIGtub3cgYWJvdXQgdGhlCgkgKiBidWZmZXIgY2hh
Y3RlcmlzdGljcyB0aGF0IGFyZSBzZXQgYnkgdGhlIGRyaXZlciBmb3IKCSAqIHByb3BlciBoYW5k
bGluZyBvZiBidWZmZXJzCgkgKiBUaGVzZSBhcmUgOiB3aWR0aCxoZWlnaHQscGl0Y2ggYW5kIGlt
YWdlIHNpemUKCSAqLwoJcHJpbnRmKCIzLiBUZXN0IEdldEZvcm1hdFxuIik7CglmbXQudHlwZSA9
IFY0TDJfQlVGX1RZUEVfVklERU9fT1VUUFVUOwoJcmV0ID0gaW9jdGwoZmRfdmlkMSwgVklESU9D
X0dfRk1ULCAmZm10KTsKCWlmIChyZXQgPCAwKSB7CgkJcHJpbnRmKCJcdEVycm9yOiBHZXQgRm9y
bWF0IGZhaWxlZDogVklEMVxuIik7CgkJcmV0dXJuIC0xOwoJfQoJZGlzcGhlaWdodCA9IGZtdC5m
bXQucGl4LmhlaWdodDsKCWRpc3BwaXRjaCA9IGZtdC5mbXQucGl4LmJ5dGVzcGVybGluZTsKCWRp
c3B3aWR0aCA9IGZtdC5mbXQucGl4LndpZHRoOwoKCXByaW50ZigiXHRkaXNwaGVpZ2h0ID0gJWRc
blx0ZGlzcHBpdGNoID0gJWRcblx0ZGlzcHdpZHRoID0gJWRcbiIsCgkgICAgICAgZGlzcGhlaWdo
dCwgZGlzcHBpdGNoLCBkaXNwd2lkdGgpOwoJcHJpbnRmKCJcdGltYWdlc2l6ZSA9ICVkXG4iLCBm
bXQuZm10LnBpeC5zaXplaW1hZ2UpOwoJCglyZXR1cm4gU1VDQ0VTUzsKfQoKLyoqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKgogKiBFeGFtcGxlIHRvIHNob3cgdmlkMSBpbiBZVVYgZm9ybWF0LE9TRDAgaW4g
UkdCNTY1IGZvcm1hdAogKiAgYW5kIE9TRDEgaXMgYXR0cmlidXRlIGZvcm1hdC4KICoqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKi8Kc3RhdGljIGludCB2cGJlX1VFXzEodm9pZCkKewoJaW50IHJldCA9IDA7
Cgl2NGwyX3N0ZF9pZCBjdXJfc3RkOwoKCURCR0VOVEVSOwoKCS8qIFNldHVwIENhcHR1cmUgKi8K
CWlmIChpbml0aWFsaXplX2NhcHR1cmUoJmN1cl9zdGQpIDwgMCkgewoJCXByaW50ZigiRmFpbGVk
IHRvIGludGlhbGl6ZSBjYXB0dXJlXG4iKTsKCQlyZXR1cm4gcmV0OwoJfQoKCS8qIFNldHVwIERp
c3BsYXkgKi8KCWlmIChjdXJfc3RkICYgVjRMMl9TVERfTlRTQykgewoJCWlmIChjaGFuZ2Vfc3lz
ZnNfYXR0cmliKEFUVFJJQl9PVVRQVVQsIERJU1BMQVlfSU5URVJGQUNFX0NPTVBPU0lURSkpCgkJ
CXJldHVybiBGQUlMVVJFOwoJCWlmIChjaGFuZ2Vfc3lzZnNfYXR0cmliKEFUVFJJQl9NT0RFLCBE
SVNQTEFZX01PREVfTlRTQykpCgkJCXJldHVybiBGQUlMVVJFOwoJCWZpbGVfc2l6ZSA9IFdJRFRI
X05UU0MgKiBIRUlHSFRfTlRTQyAqIDI7Cgl9CgllbHNlIGlmIChjdXJfc3RkICYgVjRMMl9TVERf
UEFMKSB7CgkJaWYgKGNoYW5nZV9zeXNmc19hdHRyaWIoQVRUUklCX09VVFBVVCwgRElTUExBWV9J
TlRFUkZBQ0VfQ09NUE9TSVRFKSkKCQkJcmV0dXJuIEZBSUxVUkU7CgkJaWYgKGNoYW5nZV9zeXNm
c19hdHRyaWIoQVRUUklCX01PREUsIERJU1BMQVlfTU9ERV9QQUwpKQoJCQlyZXR1cm4gRkFJTFVS
RTsKCQlmaWxlX3NpemUgPSBXSURUSF9QQUwgKiBIRUlHSFRfUEFMICogMjsKCX0KCWVsc2UgaWYg
KGN1cl9zdGQgJiBWNEwyX1NURF83MjBQXzYwKSB7CgkJaWYgKGNoYW5nZV9zeXNmc19hdHRyaWIo
QVRUUklCX09VVFBVVCwgRElTUExBWV9JTlRFUkZBQ0VfQ09NUE9ORU5UKSkKCQkJcmV0dXJuIEZB
SUxVUkU7CgkJaWYgKGNoYW5nZV9zeXNmc19hdHRyaWIoQVRUUklCX01PREUsIERJU1BMQVlfTU9E
RV83MjBQKSkKCQkJcmV0dXJuIEZBSUxVUkU7CgkJZmlsZV9zaXplID0gV0lEVEhfNzIwUCAqIEhF
SUdIVF83MjBQICogMjsKCX0KCWVsc2UgaWYgKGN1cl9zdGQgJiBWNEwyX1NURF8xMDgwSV82MCkg
ewoJCWlmIChjaGFuZ2Vfc3lzZnNfYXR0cmliKEFUVFJJQl9PVVRQVVQsIERJU1BMQVlfSU5URVJG
QUNFX0NPTVBPTkVOVCkpCgkJCXJldHVybiBGQUlMVVJFOwoJCWlmIChjaGFuZ2Vfc3lzZnNfYXR0
cmliKEFUVFJJQl9NT0RFLCBESVNQTEFZX01PREVfMTA4MEkpKQoJCQlyZXR1cm4gRkFJTFVSRTsK
CQlmaWxlX3NpemUgPSBXSURUSF8xMDgwSSAqIEhFSUdIVF8xMDgwSSAqIDI7Cgl9IGVsc2UgewoJ
CXByaW50ZigiQ2Fubm90IGRpc3BsYXkgdGhpcyBzdGFuZGFyZFxuIik7CgkJcmV0dXJuIEZBSUxV
UkU7Cgl9CgoJLyogU2V0dXAgVklEMSBvdXRwdXQgKi8KCWlmICgoaW5pdF92aWQxX2RldmljZShj
dXJfc3RkKSkgPCAwKSB7CgkJcHJpbnRmKCJcbkZhaWxlZCB0byBpbml0IHZpZDEgd2luZG93ICIp
OwoJCXJldHVybiBGQUlMVVJFOwoJfQoJCglyZXQgPSBzdGFydF9sb29wKCk7CglpZiAocmV0KQoJ
CXByaW50ZigiXHRFcnJvcjogVmlkZW8gbG9vcGJhY2sgaGFkIHNvbWUgZXJyb3JzXG4iKTsKCXBy
aW50ZigiVmlkZW8gbG9vcGJhY2sgY29tcGxldGVkIHN1Y2Nlc3NmdWxseVxuIik7CgoJLyoKCSAq
IE9uY2UgdGhlIHN0cmVhbWluZyBpcyBkb25lICBzdG9wIHRoZSBkaXNwbGF5CgkgKiBoYXJkd2Fy
ZQoJICovCglwcmludGYoIjguIFRlc3QgU1RSRUFNX09GRiAtIFxuIik7CglyZXQgPSBzdG9wX2Rp
c3BsYXkoZmRfdmlkMSk7CglpZiAocmV0IDwgMCkgewoJCXByaW50ZigiXHRFcnJvcjogQ291bGQg
bm90IHN0b3AgZGlzcGxheVxuIik7CgkJcmV0dXJuIHJldDsKCX0KCgkvKiBSZWxlYXNlIGRpc3Bs
YXkgY2hhbm5lbCAqLwoJcHJpbnRmKCI5LiBUZXN0IGJ1ZmZlciB1bm1hcHBpbmcgJiBjbG9zaW5n
IG9mIGRldmljZSAtIFxuIik7CglyZWxlYXNlX2Rpc3BsYXkoJmZkX3ZpZDEpOwoKCXJldCA9IHN0
b3BfY2FwdHVyZShmZENhcHR1cmUpOwoJaWYgKHJldCA8IDApCgkJcHJpbnRmKCJFcnJvciBpbiBW
SURJT0NfU1RSRUFNT0ZGOmNhcHR1cmVcbiIpOwoKCXJlbGVhc2VfY2FwdHVyZSgmZmRDYXB0dXJl
KTsKCWNsb3NlKGZkX29zZDApOwoJcHJpbnRmKCJET05FIEFMTFxuXG5cbiIpOwoKCURCR0VYSVQ7
CglyZXR1cm4gcmV0Owp9CgovKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgogKglGdW5jdGlvbiB3aWxs
IHVzZSB0aGUgU3lzRlMgaW50ZXJmYWNlIHRvIGNoYW5nZSB0aGUgb3V0cHV0IGFuZCBtb2RlCiAq
LwpzdGF0aWMgaW50IGNoYW5nZV9zeXNmc19hdHRyaWIoY2hhciAqYXR0cmlidXRlLCBjaGFyICp2
YWx1ZSkKewoJaW50IHN5c2ZkID0gLTE7CgljaGFyIGluaXRfdmFsWzMyXTsKCWNoYXIgYXR0cmli
X3RhZ1sxMjhdOwoKCWJ6ZXJvKGluaXRfdmFsLCBzaXplb2YoaW5pdF92YWwpKTsKCXN0cmNweShh
dHRyaWJfdGFnLCAiL3N5cy9jbGFzcy9kYXZpbmNpX2Rpc3BsYXkvY2gwLyIpOwoJc3RyY2F0KGF0
dHJpYl90YWcsIGF0dHJpYnV0ZSk7CgoJc3lzZmQgPSBvcGVuKGF0dHJpYl90YWcsIE9fUkRXUik7
CglpZiAoIXN5c2ZkKSB7CgkJcHJpbnRmKCJFcnJvcjogY2Fubm90IG9wZW4gJWRcbiIsIHN5c2Zk
KTsKCQlyZXR1cm4gRkFJTFVSRTsKCX0KCXByaW50ZigiJXMgd2FzIG9wZW5lZCBzdWNjZXNzZnVs
bHlcbiIsIGF0dHJpYl90YWcpOwoKCXJlYWQoc3lzZmQsIGluaXRfdmFsLCAzMik7Cglsc2Vlayhz
eXNmZCwgMCwgU0VFS19TRVQpOwoJcHJpbnRmKCJDdXJyZW50ICVzIHZhbHVlIGlzICVzXG4iLCBh
dHRyaWJ1dGUsIGluaXRfdmFsKTsKCgl3cml0ZShzeXNmZCwgdmFsdWUsIDEgKyBzdHJsZW4odmFs
dWUpKTsKCWxzZWVrKHN5c2ZkLCAwLCBTRUVLX1NFVCk7CgoJbWVtc2V0KGluaXRfdmFsLCAnXDAn
LCAzMik7CglyZWFkKHN5c2ZkLCBpbml0X3ZhbCwgMzIpOwoJbHNlZWsoc3lzZmQsIDAsIFNFRUtf
U0VUKTsKCXByaW50ZigiQ2hhbmdlZCAlcyB0byAlc1xuIiwgYXR0cmlidXRlLCBpbml0X3ZhbCk7
CgoJY2xvc2Uoc3lzZmQpOwoJcmV0dXJuIFNVQ0NFU1M7Cn0KCi8qKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqCiogbWVudSBmdW5jdGlvbgoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqLwp2b2lkIG1lbnUodm9p
ZCkKewoJcHJpbnRmKCJVc2FnZTogdjRsMl9tbWFwX2xvb3BiYWNrIC1zIDxmbGFnPlxuIik7Cglw
cmludGYoImZsYWcgPSAwIGZvciBpbmZpbml0ZSBsb29wLCAxIC0gZm9yIDUwMCBmcmFtZXNcbiIp
Owp9CgoKLyoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKi8KLyogbWFpbiBmdW5jdGlvbiAqLwppbnQgbWFp
bihpbnQgYXJnYywgY2hhciAqYXJndltdKQp7CglpbnQgcmV0ID0gMCwgZCwgaW5kZXg7CgljaGFy
IHNob3J0b3B0aW9uc1tdID0gImk6czpkOnc6cDptOmY6bDpoOmI6dDpjOiI7CgoJREJHRU5URVI7
CgoJLyogYnkgZGVmYXVsdCB1c2UgY29tcG9zaXRlICovCglmb3IgKDs7KSB7CgkJZCA9IGdldG9w
dF9sb25nKGFyZ2MsIGFyZ3YsIHNob3J0b3B0aW9ucywgKHZvaWQgKilOVUxMLCAmaW5kZXgpOwoJ
CWlmICgtMSA9PSBkKQoJCQlicmVhazsKCQlzd2l0Y2ggKGQpIHsKCQljYXNlICdmJzoKCQkJZmll
bGQgPSBhdG9pKG9wdGFyZyk7CgkJCWJyZWFrOwoJCWNhc2UgJ2knOgoJCQl2cGZlX2lucHV0ID0g
YXRvaShvcHRhcmcpOwoJCQlicmVhazsKCQljYXNlICdtJzoKCQkJaW5wdXRfc3RkID0gYXRvaShv
cHRhcmcpOwoJCQlicmVhazsKCQljYXNlICdwJzoKCQkJcHJpbnRmbiA9IGF0b2kob3B0YXJnKTsK
CQljYXNlICdzJzoKCQljYXNlICdTJzoKCQkJc3RyZXNzX3Rlc3QgPSBhdG9pKG9wdGFyZyk7CgkJ
CWJyZWFrOwoJCWNhc2UgJ2wnOgoJCWNhc2UgJ0wnOgoJCQljcl93aWR0aCA9IGF0b2kob3B0YXJn
KTsKCQkJYnJlYWs7CgkJY2FzZSAnaCc6CgkJY2FzZSAnSCc6CgkJCWNyX2hlaWdodCA9IGF0b2ko
b3B0YXJnKTsKCQkJYnJlYWs7CgkJY2FzZSAnYic6CgkJY2FzZSAnQic6CgkJCWNyX2xlZnQgPSBh
dG9pKG9wdGFyZyk7CgkJCWJyZWFrOwoJCWNhc2UgJ3QnOgoJCWNhc2UgJ1QnOgoJCQljcl90b3Ag
PSBhdG9pKG9wdGFyZyk7CgkJCWJyZWFrOwoJCWNhc2UgJ2MnOgoJCWNhc2UgJ0MnOgoJCQljcm9w
X2VuID0gYXRvaShvcHRhcmcpOwoJCQlicmVhazsKCQlkZWZhdWx0OgoJCQltZW51KCk7CgkJCWV4
aXQoMSk7CgkJfQoJfQoKCWlmIChlbl9jYXB0dXJlX3RvX2ZpbGUpIHsKCQlmcF9jYXB0dXJlID0g
Zm9wZW4oRklMRV9DQVBUVVJFLCAid2IiKTsKCQlpZiAoZnBfY2FwdHVyZSA9PSBOVUxMKSB7CgkJ
CXByaW50ZigiVW5hYmxlIHRvIG9wZW4gZmlsZSAlcyBmb3IgY2FwdHVyZVxuIiwgRklMRV9DQVBU
VVJFKTsKCQkJZXhpdCgxKTsKCQl9Cgl9CgoJcmV0ID0gdnBiZV9VRV8xKCk7CglEQkdFWElUOwoJ
cmV0dXJuIHJldDsKfQo=

--_002_7680727375697474656579736966697574757078687976656679687_--

--_002_A69FA2915331DC488A831521EAE36FE4016A6ECCD6dlee06enttico_--
