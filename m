Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n38CnBlL015218
	for <video4linux-list@redhat.com>; Wed, 8 Apr 2009 08:49:11 -0400
Received: from mail-ew0-f170.google.com (mail-ew0-f170.google.com
	[209.85.219.170])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n38CmqxP029785
	for <video4linux-list@redhat.com>; Wed, 8 Apr 2009 08:48:53 -0400
Received: by ewy18 with SMTP id 18so109143ewy.3
	for <video4linux-list@redhat.com>; Wed, 08 Apr 2009 05:48:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090122123009.5f981cf0@free.fr>
References: <6dd519ae0901181629m4a79732ala0daa870cefa74cc@mail.gmail.com>
	<20090119092610.65a2a90a@free.fr>
	<6dd519ae0901201251wb924d39k468627b7c778e3bf@mail.gmail.com>
	<20090121192634.5fc27ccf@free.fr>
	<6dd519ae0901211253t539c56dcm9656d0cae2b5f25c@mail.gmail.com>
	<20090122123009.5f981cf0@free.fr>
Date: Wed, 8 Apr 2009 15:48:52 +0300
Message-ID: <6dd519ae0904080548q48a2c02ctedf68a2720f0c370@mail.gmail.com>
From: Brian Marete <bgmarete@gmail.com>
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: multipart/mixed; boundary=0015174c172ac2b00b04670a8de5
Cc: Video4linux-list <video4linux-list@redhat.com>
Subject: Re: Problem streaming from gspca_t613 Webcam
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

--0015174c172ac2b00b04670a8de5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On Thu, Jan 22, 2009 at 2:30 PM, Jean-Francois Moine <moinejf@free.fr> wrote:
> I added your unknown sensor to the t613 subdriver. May you try the new
> version in my mercurial repository?
>

Hello Jean-Francois,

Sorry, got busy and could not reply sooner.

The good news is that I can now stream from the webcam! Thank you very much!

However, I have a problem:

0) The image is very blurred (little or no detail discernible) and the
colors are wrong. Also, the image seems to be mirroe inverted. See
attached t613_blurred_bad_color_inverted.dat file to get an idea of
what I am talking about. In the image, I am holding up a green lighter
with my left hand. The image is capture -- as per your instructions --
using `svv -rg'

See also attached, the output from dmesg.

I am testing with todays tip from your gspca development git repo.

I am happy to capture more USB traces -- see previous emails on this
thread for original traces. I also now have the time to experiment.
Any hints about how I can solve this problem will be appreciated.

Thanks a lot for your help!

--
B. Gitonga Marete
Tel: +254-722-151-590

--0015174c172ac2b00b04670a8de5
Content-Type: text/plain; charset=US-ASCII; name="t613_dmesg.txt"
Content-Disposition: attachment; filename="t613_dmesg.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fta0krpq1

WyA0ODI5LjcxMTg3M10gZ3NwY2E6IG1haW4gZGVyZWdpc3RlcmVkClsgNzA0NC40MjQwNDddIHVz
YiAzLTI6IG5ldyBmdWxsIHNwZWVkIFVTQiBkZXZpY2UgdXNpbmcgdWhjaV9oY2QgYW5kIGFkZHJl
c3MgMwpbIDcwNDQuNTkxOTUxXSB1c2IgMy0yOiBjb25maWd1cmF0aW9uICMxIGNob3NlbiBmcm9t
IDEgY2hvaWNlClsgNzA0NS4wMDA5ODNdIExpbnV4IHZpZGVvIGNhcHR1cmUgaW50ZXJmYWNlOiB2
Mi4wMApbIDcwNDUuMDAzNTM4XSBnc3BjYTogbWFpbiB2Mi41LjAgcmVnaXN0ZXJlZApbIDcwNDUu
MDA5MDI1XSBnc3BjYTogcHJvYmluZyAxN2ExOjAxMjgKWyA3MDQ1LjAxMTc5OF0gdDYxMzogc2Vu
c29yICdvdGhlcicKWyA3MDQ1LjA0OTkxNl0gZ3NwY2E6IHByb2JlIG9rClsgNzA0NS4wNDk5Mzld
IHVzYmNvcmU6IHJlZ2lzdGVyZWQgbmV3IGludGVyZmFjZSBkcml2ZXIgdDYxMwpbIDcwNDUuMDQ5
OTQzXSB0NjEzOiByZWdpc3RlcmVkClsgNzI2OS40MjcwMzRdIGdzcGNhOiBJU09DIGRhdGEgZXJy
b3I6IFsyMF0gbGVuPTU0LCBzdGF0dXM9LTg0ClsgNzM4MC41OTM2NzldIGdzcGNhOiBJU09DIGRh
dGEgZXJyb3I6IFswXSBsZW49NTQsIHN0YXR1cz0tODQKCg==
--0015174c172ac2b00b04670a8de5
Content-Type: chemical/x-mopac-input;
	name="t613_blurred_bad_color_inverted.dat"
Content-Disposition: attachment;
	filename="t613_blurred_bad_color_inverted.dat"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fta0k9kp0

/9j/4AAQSkZJRgABAQEASABIAAD/4QAdVEFTQ09SUCBKUEVHIDIwMDUuSmFudWFyeSAg/9sAhAAR
CwsOCwsRDgsOERERExkpGRkWFhkyJCQcKTo0PT06NDo3QkpeUEJFWEU3OlNuU1hgY2lraT9NdHx0
ZnxeZmlmARkcHCQeJEgnJ0iXZlVml5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eX
l5eXl5eXl5eXl5eXl5f/xAGiAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgsBAAMBAQEBAQEB
AQEAAAAAAAABAgMEBQYHCAkKCxAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKB
kaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZn
aGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT
1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6EQACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYT
UWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZX
WFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPE
xcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/wAARCAHgAoADASEAAhEBAxEB/9oA
DAMBAAIRAxEAPwB0HNvB/wBc1/lT6qrpaWinTgKUCinS4pwp0UoFLiinTsUoFFKlxSgUU6MUuKKK
WlxTp0YHcUuKKKNtG2iil20baKKTFNwKKKQ000UqjZaZs9qVKk2Zp3l0qKXy17qPyp+zsRRTp+KA
o7U6KXaKXFFFJijHtRRSfSk2j0FFFLikp0UlFFFJRSopKSlRSUUUUlJTpUUnFKiikoopKKKKT3pK
KVH4U2lRRSUUUlJTopKKVKkoxRRSYpDRRSUUqKSkooopKKKng/49oP8Armv8qkFVTpQaWinSinCi
ilFOFOinUtFFLThRTpaWiilpRTopaWinS0UUUUtOnS4oxRRSYplKppuKSiim7aQR5znFKil8ulC0
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
RRS0UUVqW/8Ax62//XJafV1dFNpU6SlopUopwoopwpwp06cKXNFOmlqjaSlSqIyU3zKVKm+ZRvoo
pham5opUlJSooozRRRmiilTaSiim0lFFFFFFJRRRRRRRRSUUUUUUqSiiiiiiiiiiiilooooop0UU
UUtFFFOFFFKiiinSUlFKikoopKSiiiiiiiiiikpaKKSiiiiiiiiiiiiloopaKKK04P8Aj2g/65L/
ACp+aqropKKKSgUUU4U4UU6cKcKdFLTSaKdRM1Qs1TU0wtTd1KlRuooopKSilSZpKKKKKKKM0UUU
lJRRSUlFFJRRRRRRRRRRRSUtFFJRRRRSUUqKKKKKKKKWiiiiiinRSUUqKcKKKWlop0UUUqSkoopK
SiikoooooooopKKKKKKKKKKKKSiilooooooopaWiitGD/j2g/wCua0/NVV0maTNKiinCiinCnCnT
pwp1OikqNjSoqFjUZNKpqM0lKlSiiiikpM0UUlFFFFFFFJmjNFFJSUUqKKKdJRRSoooooooopKWi
ikoop0UlFKiiiiiiinS0UUqKSinRRRSopaKKUUuaKKKKKKSiiim0UUUlFFFFFFFFFFFJRRRRRRRR
RRRRRRRRRRRS0tFFX4j+4i/3F/lS5p1VGaM0UUU4UU6eKeKdOnClooppNQsaKKiY1GTSqaZRSpUt
FFFJSUUU2iiijNFFFJRRRRRRRSUUUUUUUUUUUUUUUqKSinRRRSopKKKKKKKKKKKKKKKKKKKSiiii
iiilpaKKWiiiikoopKSiiiiiiikooooooooooooooooooopKKKWiiiilooq5Gf3Mf+4KXdTqqN1L
mlRSg05adOpBTxTopwozRTqMmomNKlUZqM0qVNpaKVFJRRSUlFFJRRRRRRRSUUUqKKKdFFFFFFFF
FFFFJRRSpaSiiiiiiiiiikoooooooooooopKKKKKKKKKKKKWiilooopKKKKSiiikpaKKSloopKKK
KKKKKKKKKKSiiloooopaKKKKKKsqf3af7opN1FOjNOBoop4NPU06dPFPFOnTs00minUZNRk0qmoy
aZSpUUUUUlGaKKSkoopKKKKKKKKKKKKKKKKKKKKKKKKSiiiiiilRRRTooopUUlFFFFFFFFFFFFFF
JRRRRRRRRRRRRS0UUUUUUlFFFFFFFJRRRRRRRRRRRRSUUUtFFFFFFFFFFFLRRRRRRRUw+4n+7RRT
pKcDRRT1qRadOniniinTqYTRRTCajJopVGabSpUUUUUlJRRRSUUUUUUUUUUUlFFFFLRRSUUUUUUU
UUUUqKKKKKKKKKKKKSiinRRRSooooopKKKKKKKSlooooooooooooooooooooooopKKKKKKKKKKKK
SiiiloooooopaKKKKKKKKKKKkH3V+lFFFFKKKdSLUi06dSCnCinRTSaKKjJphpUqZTaKVFFFFJSU
UUUlFFFFFFLSUUUUlFFLSUUUUUUUUUUUUUUUtJRSpaSiilpKKKKKKKKKKKKSiiiiiiiiiikooopa
KKKKKKKKKKKKKKKWiiikpKKKKSiilooopKKKKWiiiiiiilooooooooooop4+6v0oooopwooqRakF
FVUgpRTp0lNY0UVGaYaVTTaSiikoopUlJRRRRRTooooopKKKKKKKWkooooooopaKKSiiiiiilRRR
RRRRRSUUUUtFFFFJRRRRRRRSUUUtFFFFFFFFFFFFFFFFAoop1LRRTaSiikoooopKKKWkoopaKKKK
WiiiiiiiiiiiiiinD7o+lFFOgU9aKKlWpBRTpwpadOiozRSphqM0qVJSUUUlFFFJSUUUUUUUUUUU
UUUqKKKdFFFFFFFFFFFFFJRRRS0UqKKKKSiiiiiiiiiiiiiiiikoooooooooooooooooopaSiilp
RRRThRRRSGm0UUlFFFJRRRRRRRRS0UUtFFFLSUUUUUUUUUUUo+6KKKKcKkUUU6lUU8CinThRTp0h
qM0UqjNMNKlSUlFFJSUUUUlFFFLRRRRRSooop0UUUUUUUUUlFFLSUUUUUUqKKKKKKKKKKKKKKKKK
KKKKSiiiiiiiiiiiiiiiiiiiiiiiiiiinCiinClooppptFFJSUUUUUUUUUUUopaKKKKKKKKKKKSi
iiiiilHSnCiinqKlUUU6kUU8CnTp2KQ0U6YaiY0qVRmm0UqSkooopKKKSkopUUtFFFFFFFFFFFLR
ToooopKKKVFFFFFFFFJS0UUlFFFFFFFFFFFFFFFFJRRRRRRRRRRRRRRRRRRRRRRRRRRS0ooopwpa
KKaTTTRRSUUUUUUUUUUUUUtFFLRRRSUUUUlFFFFFFFOHQU4UUVItToKKqpFFOAp06dimGiio2qFq
VKmU2ilSUlFKkooopM0maKKKKKKKWiiigUU6WiiiiiiiikooozRRSpKWiikoooooooozRRRRRRRR
RRRSUUUUUUUUUZoooooooozRRRRRRRmjNFFFKDRRTs0ZooptJmiijNGaKKSiiijNLmiiloFFFLmk
zRRRSUUUZozRRRmjNFFOHApwI9aKKlRl/vCp1kj/AL6/nRVVIssf/PRPzpwmi/56J+dOnQZ4v+ei
fnTDNH/fX86KKhaVP7y/nUZdfUUqmo9w9aTcKKVJketGaKKTNJmiiiiiiiiiikpaKKKXNFFGaKKK
KKKdJRRSoooooooopKKKKKKKKKKKKKKKKKKKKSiiiiiiiiiiiiiiiiiiiiiiiiiiiilooopaKKSk
oooooooooooooopaKKKKKKKKSiiiiiiiiiigAP/Z
--0015174c172ac2b00b04670a8de5
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--0015174c172ac2b00b04670a8de5--
