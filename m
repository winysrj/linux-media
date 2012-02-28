Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:47728 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754231Ab2B1Dix (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Feb 2012 22:38:53 -0500
Received: by qcsc20 with SMTP id c20so2168941qcs.4
        for <linux-media@vger.kernel.org>; Mon, 27 Feb 2012 19:38:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAH9_wRN9bA8JTViBA6sWk9aVOU1Pbr5bPFvNh2MCsGUVjnr9qg@mail.gmail.com>
References: <CAH9_wRN5=nHtB9M3dL4wvZGL3+mb4_TfS=uPun_13D7n0E3CKA@mail.gmail.com>
 <CAKnK67T=obVTWkzZqVtv+PninjkbLp1os5AnsoZ+j=NGFFMWLA@mail.gmail.com>
 <CAH9_wRNGERctBxYT5NNEHOhuzWZYF2yKxG4BA6pzPzBWPy8_3Q@mail.gmail.com> <CAH9_wRN9bA8JTViBA6sWk9aVOU1Pbr5bPFvNh2MCsGUVjnr9qg@mail.gmail.com>
From: "Aguirre, Sergio" <saaguirre@ti.com>
Date: Mon, 27 Feb 2012 21:38:31 -0600
Message-ID: <CAKnK67Qk6pJ1LQBsi_V3OfadzEXHV8RnaOOxT3MK7Hu4zsk9dg@mail.gmail.com>
Subject: Re: Video Capture Issue
To: Sriram V <vshrirama@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=20cf3074b0d827de8104b9fdf76f
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--20cf3074b0d827de8104b9fdf76f
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Sriram,

On Sun, Feb 26, 2012 at 8:54 AM, Sriram V <vshrirama@gmail.com> wrote:
> Hi,
> =A0When I take the dump of the buffer which is pointed by "DATA MEM
> PING ADDRESS". It always shows 0x55.
> =A0Even if i write 0x00 to the address. I do notice that it quickly
> changes to 0x55.
> =A0Under what conditions could this happen? What am i missing here.

If you're using "yavta" for capture, notice that it clears out the
buffers before queuing them in:

static int video_queue_buffer(struct device *dev, int index, enum
buffer_fill_mode fill)
{
	struct v4l2_buffer buf;
	int ret;

	...
	...
	if (dev->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT) {
		...
	} else {
		if (fill & BUFFER_FILL_FRAME)
			memset(dev->buffers[buf.index].mem, 0x55, dev->buffers[index].size);
		if (fill & BUFFER_FILL_PADDING)
			memset(dev->buffers[buf.index].mem + dev->buffers[index].size,
			       0x55, dev->buffers[index].padding);
	}
	...
}

So, just make sure this condition is not met.

>
> =A0I do notice that the OMAP4 ISS is tested to work with OV5640 (YUV422
> Frames) and OV5650 (Raw Data)
> =A0When you say 422 Frames only. Do you mean 422-8Bit Mode?.

Yes. When saving YUV422 to memory, you can only use this mode AFAIK.

>
> =A0I havent tried RAW12 which my device gives, Do i have to update only
> the Data Format Selection register
> =A0of the ISS =A0for RAW12?

Ok, now it makes sense.

So, if your CSI2 source is giving, you need to make sure:

CSI2_CTX_CTRL2_0.FORMAT[9:0] is:

- 0xAC: RAW12 + EXP16
or
- 0x2C: RAW12

The difference is that the EXP16 variant, will save to memory in
expansion to 2 bytes, instead of 12 bits, so it'll be byte aligned.

Can you try attached patch?

Regards,
Sergio

>
> =A0Please advice.
>
>
> On Thu, Feb 23, 2012 at 11:24 PM, Sriram V <vshrirama@gmail.com> wrote:
>> Hi,
>> =A01) An Hexdump of the captured file shows 0x55 at all locations.
>> =A0 =A0 =A0Is there any buffer location i need to check.
>> =A02) I have tried with =A0"devel" branch.
>> =A03) Changing the polarities doesnt help either.
>> =A04) The sensor is giving out YUV422 8Bit Mode,
>> =A0 =A0 =A0Will 0x52001074 =3D 0x0A00001E (UYVY Format) =A0it bypass the=
 ISP
>> =A0 =A0 =A0 and dump directly into memory.
>>
>> On 2/23/12, Aguirre, Sergio <saaguirre@ti.com> wrote:
>>> Hi Sriram,
>>>
>>> On Thu, Feb 23, 2012 at 11:25 AM, Sriram V <vshrirama@gmail.com> wrote:
>>>> Hi,
>>>> =A01) I am trying to get a HDMI to CSI Bridge chip working with OMAP4 =
ISS.
>>>> =A0 =A0 =A0The issue is the captured frames are completely green in co=
lor.
>>>
>>> Sounds like the buffer is all zeroes, can you confirm?
>>>
>>>> =A02) The Chip is configured to output VGA Color bar sequence with
>>>> YUV422-8Bit and
>>>> =A0 =A0 =A0 uses datalane 0 only.
>>>> =A03) The Format on OMAP4 ISS =A0is UYVY (Register 0x52001074 =3D 0x0A=
00001E)
>>>> =A0I am trying to directly dump the data into memory without ISP proce=
ssing.
>>>>
>>>>
>>>> =A0Please advice.
>>>
>>> Just to be clear on your environment, which branch/commitID are you bas=
ed
>>> on?
>>>
>>> Regards,
>>> Sergio
>>>
>>>>
>>>> --
>>>> Regards,
>>>> Sriram
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-media"=
 in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>>
>>
>>
>> --
>> Regards,
>> Sriram
>
>
>
> --
> Regards,
> Sriram

--20cf3074b0d827de8104b9fdf76f
Content-Type: text/x-patch; charset=US-ASCII; name="omap4iss_forSriramV_20120228.diff"
Content-Disposition: attachment;
	filename="omap4iss_forSriramV_20120228.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gz6dzkf20

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvdmlkZW8vb21hcDRpc3MvaXNzX2NzaTIuYyBiL2Ry
aXZlcnMvbWVkaWEvdmlkZW8vb21hcDRpc3MvaXNzX2NzaTIuYwppbmRleCAwNDk4NWEwLi4wZThh
MDY5IDEwMDY0NAotLS0gYS9kcml2ZXJzL21lZGlhL3ZpZGVvL29tYXA0aXNzL2lzc19jc2kyLmMK
KysrIGIvZHJpdmVycy9tZWRpYS92aWRlby9vbWFwNGlzcy9pc3NfY3NpMi5jCkBAIC0xMDYsNiAr
MTA2LDEwIEBAIHN0YXRpYyBjb25zdCB1bnNpZ25lZCBpbnQgY3NpMl9pbnB1dF9mbXRzW10gPSB7
CiAJVjRMMl9NQlVTX0ZNVF9TR0JSRzhfMVg4LAogCVY0TDJfTUJVU19GTVRfU0dSQkc4XzFYOCwK
IAlWNEwyX01CVVNfRk1UX1NSR0dCOF8xWDgsCisJVjRMMl9NQlVTX0ZNVF9TQkdHUjEyXzFYMTIs
CisJVjRMMl9NQlVTX0ZNVF9TR0JSRzEyXzFYMTIsCisJVjRMMl9NQlVTX0ZNVF9TR1JCRzEyXzFY
MTIsCisJVjRMMl9NQlVTX0ZNVF9TUkdHQjEyXzFYMTIsCiAJVjRMMl9NQlVTX0ZNVF9VWVZZOF8x
WDE2LAogCVY0TDJfTUJVU19GTVRfWVVZVjhfMVgxNiwKIH07CkBAIC0xNzEsNiArMTc1LDIzIEBA
IHN0YXRpYyBjb25zdCB1MTYgX19jc2kyX2ZtdF9tYXBbXVsyXVsyXSA9IHsKIAkJCTAsCiAJCX0s
CiAJfSwKKwkvKiBSQVcxMiBmb3JtYXRzICovCisJeworCQkvKiBPdXRwdXQgdG8gbWVtb3J5ICov
CisJCXsKKwkJCS8qIE5vIERQQ00gZGVjb21wcmVzc2lvbiAqLworCQkJQ1NJMl9QSVhfRk1UX1JB
VzEyX0VYUDE2LAorCQkJLyogRFBDTSBkZWNvbXByZXNzaW9uICovCisJCQkwLAorCQl9LAorCQkv
KiBPdXRwdXQgdG8gYm90aCAqLworCQl7CisJCQkvKiBObyBEUENNIGRlY29tcHJlc3Npb24gKi8K
KwkJCUNTSTJfUElYX0ZNVF9SQVcxMl9WUCwKKwkJCS8qIERQQ00gZGVjb21wcmVzc2lvbiAqLwor
CQkJMCwKKwkJfSwKKwl9LAogCS8qIFlVVjQyMiBmb3JtYXRzICovCiAJewogCQkvKiBPdXRwdXQg
dG8gbWVtb3J5ICovCkBAIC0yMjAsOSArMjQxLDE1IEBAIHN0YXRpYyB1MTYgY3NpMl9jdHhfbWFw
X2Zvcm1hdChzdHJ1Y3QgaXNzX2NzaTJfZGV2aWNlICpjc2kyKQogCWNhc2UgVjRMMl9NQlVTX0ZN
VF9TUkdHQjhfMVg4OgogCQlmbXRpZHggPSAyOwogCQlicmVhazsKKwljYXNlIFY0TDJfTUJVU19G
TVRfU0JHR1IxMl8xWDEyOgorCWNhc2UgVjRMMl9NQlVTX0ZNVF9TR0JSRzEyXzFYMTI6CisJY2Fz
ZSBWNEwyX01CVVNfRk1UX1NHUkJHMTJfMVgxMjoKKwljYXNlIFY0TDJfTUJVU19GTVRfU1JHR0Ix
Ml8xWDEyOgorCQlmbXRpZHggPSAzOworCQlicmVhazsKIAljYXNlIFY0TDJfTUJVU19GTVRfVVlW
WThfMVgxNjoKIAljYXNlIFY0TDJfTUJVU19GTVRfWVVZVjhfMVgxNjoKLQkJZm10aWR4ID0gMzsK
KwkJZm10aWR4ID0gNDsKIAkJYnJlYWs7CiAJZGVmYXVsdDoKIAkJV0FSTigxLCBLRVJOX0VSUiAi
Q1NJMjogcGl4ZWwgZm9ybWF0ICUwOHggdW5zdXBwb3J0ZWQhXG4iLApkaWZmIC0tZ2l0IGEvZHJp
dmVycy9tZWRpYS92aWRlby9vbWFwNGlzcy9pc3NfY3NpMi5oIGIvZHJpdmVycy9tZWRpYS92aWRl
by9vbWFwNGlzcy9pc3NfY3NpMi5oCmluZGV4IGFhODE5NzEuLmJlZWQzMzEgMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvbWVkaWEvdmlkZW8vb21hcDRpc3MvaXNzX2NzaTIuaAorKysgYi9kcml2ZXJzL21l
ZGlhL3ZpZGVvL29tYXA0aXNzL2lzc19jc2kyLmgKQEAgLTMyLDYgKzMyLDggQEAgZW51bSBpc3Nf
Y3NpMl9waXhfZm9ybWF0cyB7CiAJQ1NJMl9QSVhfRk1UX1JBVzhfRFBDTTEwX0VYUDE2ID0gMHgy
YWEsCiAJQ1NJMl9QSVhfRk1UX1JBVzhfRFBDTTEwX1ZQID0gMHgzMmEsCiAJQ1NJMl9QSVhfRk1U
X1JBVzhfVlAgPSAweDEyYSwKKwlDU0kyX1BJWF9GTVRfUkFXMTJfRVhQMTYgPSAweGFjLAorCUNT
STJfUElYX0ZNVF9SQVcxMl9WUCA9IDB4MTJjLAogCUNTSTJfVVNFUkRFRl84QklUX0RBVEExX0RQ
Q00xMF9WUCA9IDB4MzQwLAogCUNTSTJfVVNFUkRFRl84QklUX0RBVEExX0RQQ00xMCA9IDB4MmMw
LAogCUNTSTJfVVNFUkRFRl84QklUX0RBVEExID0gMHg0MCwK
--20cf3074b0d827de8104b9fdf76f--
