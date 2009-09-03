Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754764AbZICJlt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Sep 2009 05:41:49 -0400
Message-ID: <4A9F9006.6020203@hhs.nl>
Date: Thu, 03 Sep 2009 11:44:38 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Simon Farnsworth <simon.farnsworth@onelan.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: libv4l2 and the Hauppauge HVR1600 (cx18 driver) not working well
 together
References: <4A9E9E08.7090104@onelan.com> <4A9EAF07.3040303@hhs.nl> <4A9F89AD.7030106@onelan.com>
In-Reply-To: <4A9F89AD.7030106@onelan.com>
Content-Type: multipart/mixed;
 boundary="------------010407050303030806040306"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010407050303030806040306
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 09/03/2009 11:17 AM, Simon Farnsworth wrote:
> Hans de Goede wrote:
>> Hi,
>>
>> On 09/02/2009 06:32 PM, Simon Farnsworth wrote:
>>> I have a Hauppauge HVR1600 for NTSC and ATSC support, and it appears to
>>> simply not work with libv4l2, due to lack of mmap support. My code works
>>> adequately (modulo a nice pile of bugs) with a HVR1110r3, so it appears
>>> to be driver level.
>>>
>>> Which is the better route to handling this; adding code to input_v4l to
>>> use libv4lconvert when mmap isn't available, or converting the cx18
>>> driver to use mmap?
>>>
>>
>> Or modify libv4l2 to also handle devices which can only do read. There have
>> been some changes to libv4l2 recently which would make doing that feasible.
>>
> Roughly what would I need to do to libv4l2?
>
> I can see four new cases to handle:
>
> 1) driver supports read(), client wants read(), format supported by
> both. Just pass read() through to the driver.
>
>
> 3) As 1, but needs conversion. read() into a temporary buffer, convert
> with libv4lconvert (I think this needs a secondary buffer), and supply
> data from the secondary buffer to read()
>

Ok,

That was even easier then I thought it would be. Attached is a patch
(against libv4l-0.6.1), which implements 1) and 3) from above.

Please give this a try.

Regards,

Hans



>>> If it's a case of converting the cx18 driver, how would I go about doing
>>> that? I have no experience of the driver, so I'm not sure what I'd have
>>> to do - noting that if I break the existing read() support, other users
>>> will get upset.
>>
>> I don't believe that modifying the driver is the answer, we need to either
>> fix this at the libv4l or xine level.
>>
>> I wonder though, doesn't the cx18 offer any format that xine can handle
>> directly?
>>
> Not sensibly; it offers HM12 only, and Xine needs an RGB format, YV12,
> or YUYV. With a lot of rework, I could have the cx18 encode video to
> MPEG-2, then have Xine decode the resulting MPEG-2 stream, but this
> seems like overkill for uncompressed video. I could also teach Xine to
> handle HM12 natively, but that would duplicate effort already done in
> libv4l2 and libv4lconvert, which seems a bit silly to me.


--------------010407050303030806040306
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="diff"

ZGlmZiAtciA4OGE5YzJlZDYxMmUgdjRsMi1hcHBzL2xpYnY0bC9saWJ2NGwyL2xpYnY0bDIu
YwotLS0gYS92NGwyLWFwcHMvbGlidjRsL2xpYnY0bDIvbGlidjRsMi5jCVdlZCBTZXAgMDIg
MTE6MjU6MTAgMjAwOSArMDIwMAorKysgYi92NGwyLWFwcHMvbGlidjRsL2xpYnY0bDIvbGli
djRsMi5jCVRodSBTZXAgMDMgMTE6NDM6MTUgMjAwOSArMDIwMApAQCAtNTI2LDEwICs1MjYs
OSBAQAogICAgIHJldHVybiAtMTsKICAgfQogCi0gIC8qIHdlIG9ubHkgYWRkIGZ1bmN0aW9u
YWxpdHkgZm9yIHZpZGVvIGNhcHR1cmUgZGV2aWNlcywgYW5kIHdlIGRvIG5vdAotICAgICBo
YW5kbGUgZGV2aWNlcyB3aGljaCBkb24ndCBkbyBtbWFwICovCisgIC8qIHdlIG9ubHkgYWRk
IGZ1bmN0aW9uYWxpdHkgZm9yIHZpZGVvIGNhcHR1cmUgZGV2aWNlcyAqLwogICBpZiAoIShj
YXAuY2FwYWJpbGl0aWVzICYgVjRMMl9DQVBfVklERU9fQ0FQVFVSRSkgfHwKLSAgICAgICEo
Y2FwLmNhcGFiaWxpdGllcyAmIFY0TDJfQ0FQX1NUUkVBTUlORykpCisgICAgICAhKGNhcC5j
YXBhYmlsaXRpZXMgJiAoVjRMMl9DQVBfU1RSRUFNSU5HfFY0TDJfQ0FQX1JFQURXUklURSkp
CiAgICAgcmV0dXJuIGZkOwogCiAgIC8qIEdldCBjdXJyZW50IGNhbSBmb3JtYXQgKi8KQEAg
LTU2NCw2ICs1NjMsOCBAQAogICBkZXZpY2VzW2luZGV4XS5mbGFncyA9IHY0bDJfZmxhZ3M7
CiAgIGlmIChjYXAuY2FwYWJpbGl0aWVzICYgVjRMMl9DQVBfUkVBRFdSSVRFKQogICAgIGRl
dmljZXNbaW5kZXhdLmZsYWdzIHw9IFY0TDJfU1VQUE9SVFNfUkVBRDsKKyAgaWYgKCEoY2Fw
LmNhcGFiaWxpdGllcyAmIFY0TDJfQ0FQX1NUUkVBTUlORykpCisgICAgZGV2aWNlc1tpbmRl
eF0uZmxhZ3MgfD0gVjRMMl9VU0VfUkVBRF9GT1JfUkVBRDsKICAgaWYgKCFzdHJjbXAoKGNo
YXIgKiljYXAuZHJpdmVyLCAidXZjdmlkZW8iKSkKICAgICBkZXZpY2VzW2luZGV4XS5mbGFn
cyB8PSBWNEwyX0lTX1VWQzsKICAgZGV2aWNlc1tpbmRleF0ub3Blbl9jb3VudCA9IDE7CkBA
IC01NzEsNyArNTcyLDcgQEAKICAgZGV2aWNlc1tpbmRleF0uZGVzdF9mbXQgPSBmbXQ7CiAK
ICAgLyogV2hlbiBhIHVzZXIgZG9lcyBhIHRyeV9mbXQgd2l0aCB0aGUgY3VycmVudCBkZXN0
X2ZtdCBhbmQgdGhlIGRlc3RfZm10Ci0gICAgIGlzIGEgc3VwcG9ydGVkIG9uZSB3ZSB3aWxs
IGFsaWduIHRoZSByZXN1bHV0aW9uIChzZWUgdHJ5X2ZtdCBmb3Igd2h5KS4KKyAgICAgaXMg
YSBzdXBwb3J0ZWQgb25lIHdlIHdpbGwgYWxpZ24gdGhlIHJlc29sdXRpb24gKHNlZSB0cnlf
Zm10IGZvciB3aHkpLgogICAgICBEbyB0aGUgc2FtZSBoZXJlIG5vdywgc28gdGhhdCBhIHRy
eV9mbXQgb24gdGhlIHJlc3VsdCBvZiBhIGdldF9mbXQgZG9uZQogICAgICBpbW1lZGlhdGVs
eSBhZnRlciBvcGVuIGxlYXZlcyB0aGUgZm10IHVuY2hhbmdlZC4gKi8KICAgaWYgKHY0bGNv
bnZlcnRfc3VwcG9ydGVkX2RzdF9mb3JtYXQoCg==
--------------010407050303030806040306--
