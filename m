Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:50621 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbZBMKOh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2009 05:14:37 -0500
Received: by rv-out-0506.google.com with SMTP id g37so637546rvb.1
        for <linux-media@vger.kernel.org>; Fri, 13 Feb 2009 02:14:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <497598ED.3050502@parrot.com>
References: <497487F2.7070400@parrot.com>
	 <aec7e5c30901192046j1a595day51da698181d034e5@mail.gmail.com>
	 <497598ED.3050502@parrot.com>
Date: Fri, 13 Feb 2009 19:14:36 +0900
Message-ID: <aec7e5c30902130214k6a0fc8ck74b412f41fa63385@mail.gmail.com>
Subject: Re: soc-camera : sh_mobile_ceu_camera race on free_buffer ?
From: Magnus Damm <magnus.damm@gmail.com>
To: Matthieu CASTET <matthieu.castet@parrot.com>
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>
Content-Type: multipart/mixed; boundary=000e0cd1af8ca0d0ef0462ca1a5c
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--000e0cd1af8ca0d0ef0462ca1a5c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Matthieu,

[CC Morimoto-san]
[Changed list to linux-media]

On Tue, Jan 20, 2009 at 6:27 PM, Matthieu CASTET
<matthieu.castet@parrot.com> wrote:
> Magnus Damm a =E9crit :
>> On Mon, Jan 19, 2009 at 11:02 PM, Matthieu CASTET
>>> But we didn't do stop_capture, so as far I understand the controller is
>>> still writing data in memory. What prevent us to free the buffer we are
>>> writing.
>>
>> I have not looked into this in great detail, but isn't this handled by
>> the videobuf state? The videobuf has state VIDEOBUF_ACTIVE while it is
>> in use. I don't think such a buffer is freed.
> Well from my understanding form videobuf_queue_cancel [1], we call
> buf_release on all buffer.

Yeah, you are correct. I guess waiting for the buffer before freeing
is the correct way to do this. I guess vivi doesn't have to do this
since it's not using DMA.

Morimoto-san, can you check the attached patch? I've tested it on my
Migo-R board together with mplayer and it seems to work well here. I
don't think using mplayer triggers this error case though, so maybe we
should try some other application.

Cheers,

/ magnus

--000e0cd1af8ca0d0ef0462ca1a5c
Content-Type: text/x-patch; charset=US-ASCII;
	name="linux-2.6.29-media-video-sh_mobile_ceu-videobuf_waiton-20090213.patch"
Content-Disposition: attachment;
	filename="linux-2.6.29-media-video-sh_mobile_ceu-videobuf_waiton-20090213.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fr4p4jib0

LS0tIDAwMDEvZHJpdmVycy9tZWRpYS92aWRlby9zaF9tb2JpbGVfY2V1X2NhbWVyYS5jCisrKyB3
b3JrL2RyaXZlcnMvbWVkaWEvdmlkZW8vc2hfbW9iaWxlX2NldV9jYW1lcmEuYwkyMDA5LTAyLTEz
IDE4OjU1OjU1LjAwMDAwMDAwMCArMDkwMApAQCAtMTUwLDYgKzE1MCw3IEBAIHN0YXRpYyB2b2lk
IGZyZWVfYnVmZmVyKHN0cnVjdCB2aWRlb2J1Zl8KIAlpZiAoaW5faW50ZXJydXB0KCkpCiAJCUJV
RygpOwogCisJdmlkZW9idWZfd2FpdG9uKCZidWYtPnZiLCAwLCAwKTsKIAl2aWRlb2J1Zl9kbWFf
Y29udGlnX2ZyZWUodnEsICZidWYtPnZiKTsKIAlkZXZfZGJnKCZpY2QtPmRldiwgIiVzIGZyZWVk
XG4iLCBfX2Z1bmNfXyk7CiAJYnVmLT52Yi5zdGF0ZSA9IFZJREVPQlVGX05FRURTX0lOSVQ7Cg==
--000e0cd1af8ca0d0ef0462ca1a5c--
