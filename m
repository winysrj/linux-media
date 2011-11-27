Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:51436 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab1K0T15 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Nov 2011 14:27:57 -0500
Received: by wwo28 with SMTP id 28so6106073wwo.1
        for <linux-media@vger.kernel.org>; Sun, 27 Nov 2011 11:27:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4ED2899F.5090807@redhat.com>
References: <1322141949-5795-1-git-send-email-hverkuil@xs4all.nl>
	<4ED0116A.6050108@linuxtv.org>
	<201111260655.54570@orion.escape-edv.de>
	<201111261249.09740.hverkuil@xs4all.nl>
	<CAHFNz9+0_wQffFKRmPLGN8A_78KbOpssrY5OKVrqMw5saPU4-g@mail.gmail.com>
	<4ED2899F.5090807@redhat.com>
Date: Mon, 28 Nov 2011 00:57:54 +0530
Message-ID: <CAHFNz9L_U29JH2DgOyFTDU8YPKjuZqHHEfUK78R-MLY+tMuajA@mail.gmail.com>
Subject: Re: [RFCv2 PATCH 12/12] Remove audio.h, video.h and osd.h.
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Andreas Oberritter <obi@linuxtv.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: multipart/mixed; boundary=f46d0435c06807e32b04b2bc623d
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--f46d0435c06807e32b04b2bc623d
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 28, 2011 at 12:33 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 26-11-2011 19:58, Manu Abraham escreveu:
>> On Sat, Nov 26, 2011 at 5:19 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote=
:
>>> On Saturday, November 26, 2011 06:55:52 Oliver Endriss wrote:
>>>> On Friday 25 November 2011 23:06:34 Andreas Oberritter wrote:
>>>>> On 25.11.2011 17:51, Manu Abraham wrote:
>>>>>> On Fri, Nov 25, 2011 at 9:56 PM, Mauro Carvalho Chehab
>>>>>> <mchehab@redhat.com> wrote:
>>>>>>> Em 25-11-2011 14:03, Andreas Oberritter escreveu:
>>>>>>>> On 25.11.2011 16:38, Mauro Carvalho Chehab wrote:
>>>>>>>>> Em 25-11-2011 12:41, Andreas Oberritter escreveu:
>>>>>>>>>> On 25.11.2011 14:48, Mauro Carvalho Chehab wrote:
>>>>>>>>>>> If your complain is about the removal of audio.h, video.h
>>>>>>>>>>
>>>>>>>>>> We're back on topic, thank you!
>>>>>>>>>>
>>>>>>>>>>> and osd.h, then my proposal is
>>>>>>>>>>> to keep it there, writing a text that they are part of a deprec=
ated API,
>>>>>>>>>>
>>>>>>>>>> That's exactly what I proposed. Well, you shouldn't write "depre=
cated",
>>>>>>>>>> because it's not. Just explain - inside this text - when V4L2 sh=
ould be
>>>>>>>>>> preferred over DVB.
>>>>>>>>>
>>>>>>>>> It is deprecated, as the API is not growing to fulfill today's ne=
eds, and
>>>>>>>>> no patches adding new stuff to it to it will be accepted anymore.
>>>>>>>>
>>>>>>>> Haha, nice one. "It doesn't grow because I don't allow it to." Gre=
at!
>>>>>>>
>>>>>>> No. It didn't grow because nobody cared with it for years:
>>>>>>>
>>>>>>> Since 2.6.12-rc2 (start of git history), no changes ever happened a=
t osd.h.
>>>>>>>
>>>>>>> Excluding Hans changes for using it on a pure V4L device, and other=
 trivial
>>>>>>> patches not related to API changes, the last API change on audio.h =
and video.h
>>>>>>> was this patch:
>>>>>>> =A0 =A0 =A0 =A0commit f05cce863fa399dd79c5aa3896d608b8b86d8030
>>>>>>> =A0 =A0 =A0 =A0Author: Andreas Oberritter <obi@linuxtv.org>
>>>>>>> =A0 =A0 =A0 =A0Date: =A0 Mon Feb 27 00:09:00 2006 -0300
>>>>>>>
>>>>>>> =A0 =A0 =A0 =A0 =A0 =A0V4L/DVB (3375): Add AUDIO_GET_PTS and VIDEO_=
GET_PTS ioctls
>>>>>>>
>>>>>>> =A0 =A0 =A0 =A0(yet not used on any upstream driver)
>>>>>>>
>>>>>>> An then:
>>>>>>> =A0 =A0 =A0 =A0commit 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2
>>>>>>> =A0 =A0 =A0 =A0Author: Linus Torvalds <torvalds@ppc970.osdl.org>
>>>>>>> =A0 =A0 =A0 =A0Date: =A0 Sat Apr 16 15:20:36 2005 -0700
>>>>>>>
>>>>>>> =A0 =A0 =A0 =A0 =A0 =A0Linux-2.6.12-rc2
>>>>>>>
>>>>>>> No changes adding support for any in-kernel driver were ever added =
there.
>>>>>>>
>>>>>>> So, it didn't grow over the last 5 or 6 years because nobody submit=
ted
>>>>>>> driver patches requiring new things or _even_ using it.
>>>>>>>
>>>>>>>>
>>>>>>>>>>> but keeping
>>>>>>>>>>> the rest of the patches
>>>>>>>>>>
>>>>>>>>>> Which ones?
>>>>>>>>>
>>>>>>>>> V4L2, ivtv and DocBook patches.
>>>>>>>>
>>>>>>>> Fine.
>>>>>>>>
>>>>>>>>>>> and not accepting anymore any submission using them
>>>>>>>>>>
>>>>>>>>>> Why? First you complain about missing users and then don't want =
to allow
>>>>>>>>>> any new ones.
>>>>>>>>>
>>>>>>>>> I didn't complain about missing users. What I've said is that, be=
tween a
>>>>>>>>> one-user API and broad used APIs like ALSA and V4L2, the choice i=
s to freeze
>>>>>>>>> the one-user API and mark it as deprecated.
>>>>>>>>
>>>>>>>> Your assumtion about only one user still isn't true.
>>>>>>>>
>>>>>>>>> Also, today's needs are properly already covered by V4L/ALSA/MC/s=
ubdev.
>>>>>>>>> It is easier to add what's missing there for DVB than to work the=
 other
>>>>>>>>> way around, and deprecate V4L2/ALSA/MC/subdev.
>>>>>>>>
>>>>>>>> Yes. Please! Add it! But leave the DVB API alone!
>>>>>>>>
>>>>>>>>>>> , removing
>>>>>>>>>>> the ioctl's that aren't used by av7110 from them.
>>>>>>>>>>
>>>>>>>>>> That's just stupid. I can easily provide a list of used and valu=
able
>>>>>>>>>> ioctls, which need to remain present in order to not break users=
pace
>>>>>>>>>> applications.
>>>>>>>>>
>>>>>>>>> Those ioctl's aren't used by any Kernel driver, and not even docu=
mented.
>>>>>>>>> So, why to keep/maintain them?
>>>>>>>>
>>>>>>>> If you already deprecated it, why bother deleting random stuff fro=
m it
>>>>>>>> that people are using?
>>>>>>>>
>>>>>>>> There's a difference in keeping and maintaining something. You don=
't
>>>>>>>> need to maintain ioctls that haven't changed in years. Deleting
>>>>>>>> something is more work than letting it there to be used by those w=
ho
>>>>>>>> want to.
>>>>>>>
>>>>>>> Ok. Let's just keep the headers as is, just adding a comment that i=
t is now
>>>>>>> considered superseded.
>>>>>
>>>>> Thank you! This is a step into the right direction.
>>>>>
>>>>>> http://dictionary.reference.com/browse/superseded
>>>>>>
>>>>>> to set aside or cause to be set aside as void, useless, or obsolete,=
 usually
>>>>>> in favor of something mentioned; make obsolete: They superseded the
>>>>>> old statute with a new one.
>>>>>>
>>>>>> No, that's not acceptable. New DVB devices as they come will make us=
e
>>>>>> of the API and API changes might be applied.
>>>>>
>>>>> Honestly, I think we all should accept this proposal and just hope th=
at
>>>>> the comment is going to be written objectively.
>>>>
>>>> 'Hoping' is not enough for me anymore. I am deeply disappointed.
>>>> Mauro and Hans have severely damaged my trust, that v4ldvb APIs are
>>>> stable in Linux, and how things are handled in this project.
>>>>
>>>> So I request a public statement from the subsystem maintainer that
>>>> 1. The DVB Decoder API will not be removed.
>>>> 2. It can be updated if required (e.g. adding a missing function).
>>>> 3. New drivers are allowed to use this architecture.
>>>> 4. These driver will be accepted, if they follow the kernel standards.
>>>>
>>>> The reason is simple: I need to know, whether this project is still
>>>> worth investing some time, or it is better to do something else.
>>>
>>> 1) There are two APIs that do the same thing: the DVB decoder API and t=
he
>>> =A0 V4L2 API.
>>> 2) That's bad because it confuses driver developers and application dev=
elopers
>>> =A0 who have to support *two* APIs to do the same thing.
>>> 3) The DVB decoder API is used in only one DVB driver (av7110), and in =
one
>>> =A0 V4L2 driver (ivtv). The latter is easily converted to V4L2 which le=
aves only
>>> =A0 one driver, av7110.
>>> 4) A decoder API has nothing to do with DVB as a standard, it simply ta=
kes
>>> =A0 the output of the DVB part of the hardware and decodes it to the ou=
tput.
>>> =A0 That's basic V4L2 functionality.
>>
>>
>> It does, with newer scrambling systems, the decoder is tightly tied to t=
he
>> CA system(s) associated.
>>
>> According to the CI+ specification:
>>
>> "It is mandatory for the Application MMI to provide limited control
>> over the MPEG
>> decoders which enable the broadcast video and audio of the current servi=
ce to
>> be presented, additionally a full frame I-frame may be used to provide r=
ich
>> graphics backgrounds. The MMI Application may deny the application MMI
>> control of the MPEG decoder if a resource conflict results."
>>
>> What you are talking about is FTA decoders which don't have any scrambli=
ng
>> control, but almost all newer DVB decoders supporting CI+ work that way.
>> If you look at any new digital TV/service, it comes with CI+ and many pr=
oviders
>> switching over.
>>
>> Because of a wrong decision, users cannot be denied using the same.
>
> What is saying there doesn't tell how the implementation should happen, b=
ut only
> what features should be there. The control over the MPEG decoders is dire=
ctly
> available either using the audio/video DVB API or the V4L API.
>
> Also, as defined into item 3.3 - Abbreviations [1], MMI is the Man Machin=
e Interface.
> This is how ITU-T and ITU-R calls the GUI interface. Other standardizatio=
n bureaus
> share the same definition.
>
> [1] http://www.ci-plus.com/data/ci_plus_specification_v1.2.pdf
>
> As stated on item 12.1:
>
> =A0 =A0 =A0 =A0The CI Plus Application MMI shall take precedence over any=
 existing
> =A0 =A0 =A0 =A0application environment and may optionally be presented on=
 the host
> =A0 =A0 =A0 =A0native graphics plane, application plane or another displa=
y plane
> =A0 =A0 =A0 =A0that may exist between the host display and application, t=
his is shown
> =A0 =A0 =A0 =A0as a number of conceptual planes in Figure 12.3
>
> Figure 12.3 is interesting, as it shows that the Application MMI is one o=
f the
> planes that the user will view on his screen.
>
> A proper implementation of something like figure 12.3 is one of the thing=
s that
> it is easily done via V4L2 and its integration with framebuffer and the
> upcoming integration with the GPU using the shared framebuffers patches t=
hat
> are under discussions between mm, media and gpu subsystems.
>
> I can't see any way of implementing the composing of the video planes sho=
wn at
> figure 12.3 (background, video planes, optional application planes, CI Pl=
us
> Application MMI plane, Native Graphics planes) with just the DVB API.
>
> As said there:
>
> =A0 =A0 =A0 =A0The Application MMI shall support full video transparency =
enabling text
> =A0 =A0 =A0 =A0and graphics to be overlaid over the video (and possibly a=
ny native
> =A0 =A0 =A0 =A0 application). The Application MMI has a native SD resolut=
ion of
> =A0 =A0 =A0 =A0720x576 pixels and shall be scaled to full screen to match=
 the current
> =A0 =A0 =A0 =A0video aspect ratio in both SD and HD environments.
>
> The pipeline setup via the MC allows setting such planes, and the GPU/V4L=
2
> shared buffer allows passing the CI+ Application MMI to the GPU. V4L2 sub=
dev
> API can be used to control the scaler required to convert from 720x576 pi=
xels
> to the displayed resolution, and to adjust the DV timings of the output.


You don't have any planes that you can control in software. There is *no*
GPU involved, the output of the decoder goes through HDMI/HDCP to the
display. The whole concept is to avoid the user to touch/copy the video
stream/components. The host is decoder on which the MMI application
runs in secure mode. You can't take any control over those with V4L2 or
anything as you state.
You can understand the same from the attached .jpeg file

--f46d0435c06807e32b04b2bc623d
Content-Type: image/jpeg; name="cip_snapshot.jpeg"
Content-Disposition: attachment; filename="cip_snapshot.jpeg"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gvifwx1b0

/9j/4AAQSkZJRgABAQEAYABgAAD/4QBARXhpZgAASUkqAAgAAAABAGmHBAABAAAAGgAAAAAAAAAC
AAKgCQABAAAA4AEAAAOgCQABAAAAAgEAAAAAAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkS
Ew8UHRofHh0aHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/2wBDAQkJCQwLDBgNDRgy
IRwhMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjL/wAAR
CAECAeADASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgED
AwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRol
JicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWW
l5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3
+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3
AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5
OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaan
qKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIR
AxEAPwD3+sO+8YeH9OvHtLvVbaKeMgSKW/1eem49F/HFbZGelee+FdZ0TRfDV5p+uXVtbX8Nzcfb
4blgHmZpGO7aeXDKRjGcggUAdymo2j3q2S3EZuWh89Ywckx5xu+map6p4m0fRbqO21C+jgmkTzER
gSSucZ4HTNc/pxgb4h2LWtube3Ph8eVC0ewxr5owu3tgdu1M1Yaofihb/wBlfYxN/Yz7vtW7bt85
em3vnFAHSReI9JnhspoL2KaK+n+z27xHcHkCsxXI6cI3X0rVFed3WiTaLfeH2up45rq+8RtdzGJC
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
ZLlkrozqUo1FZnDWq6ZexebbLbypnBKgHB9D6H2qf7Daf8+8X/fIrd1Dw5p2ozG4khMV1jAuYGMc
n4sOo9jkVlS6BrNpk2t9BeRj+C6Ty3/77QY/8drjngr605fJ/wCf/DHnVMHVXwu5FDbQQZ8mGOPc
cnYoGfrUpUHrzVVpNUt/+PrRLsf7VuySr+h3fpUTaxbxgGaG9hz/AM9bOVf/AGWud4TEL7N/TX8j
jlSqJ6pl3yo+uxc/SnBQOgFUP7b0/wD57n/vhv8AClXV7eQZhgvZv+uVnK3/ALLS+rYh/ZZPs5vo
y9RVZX1S4/49tFucdnuHSJf5lv0q1F4f1e6wbrUIbRD/AAWib3/77fj/AMdrSOBqv4rL5/5XNoYS
rLoV7q+trKMSXMyRKTtXceWPoB1J9hSW1hqmssPlk02yPWR1xPIP9lT9we7c+w61vad4d07TJfPh
g33JGDcTMZJSPTc3IHsOK1MV2U8PSparV93/AJf5ndRwMY6z1KmnaZa6Xarb2kQjjBye5YnqSTyS
fU81coorVtt3Z37BRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFF
FFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABQaKKAExR
gelFFIYUhooqhC9qWiipQwooopiCiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKAP
/9k=
--f46d0435c06807e32b04b2bc623d--
