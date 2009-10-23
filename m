Return-path: <linux-media-owner@vger.kernel.org>
Received: from exprod7og101.obsmtp.com ([64.18.2.155]:48878 "HELO
	exprod7og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751558AbZJWNh7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Oct 2009 09:37:59 -0400
Received: by fxm26 with SMTP id 26so10078948fxm.47
        for <linux-media@vger.kernel.org>; Fri, 23 Oct 2009 06:38:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <aaaa95950910230035o4c07c955jbbe74a80f79d6d69@mail.gmail.com>
References: <aaaa95950910210632p74179cv91aa9825eff8d6bd@mail.gmail.com>
	 <aaaa95950910220813y71f2f328sdb53d5c594d93094@mail.gmail.com>
	 <aaaa95950910220851l201870c8w5352f2ec889244eb@mail.gmail.com>
	 <095c6478b6c5187393b7af198449545f.squirrel@webmail.xs4all.nl>
	 <aaaa95950910230035o4c07c955jbbe74a80f79d6d69@mail.gmail.com>
Date: Fri, 23 Oct 2009 15:38:03 +0200
Message-ID: <aaaa95950910230638p28399b5dld4cbbb44e3c19c32@mail.gmail.com>
Subject: Re: [PATCH] output human readable form of the .status field from
	VIDIOC_ENUMINPUT
From: Sigmund Augdal <sigmund@snap.tv>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=0015175d0a3c36819804769a529d
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--0015175d0a3c36819804769a529d
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 23, 2009 at 9:35 AM, Sigmund Augdal <sigmund@snap.tv> wrote:
> On Fri, Oct 23, 2009 at 12:10 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote=
:
>>
>>> The attach patch modifies v4l2-ctl -I to also output signal status as
>>> detected by the driver/hardware. This info is available in the status
>>> field of the data returned by VIDIOC_ENUMINPUT which v4l2-ctl -I
>>> already calls. The strings are copied from the v4l2 api specification
>>> and could perhaps be modified a bit to fit the application.
>>>
>>> Best regards
>>>
>>> Sigmund Augdal
>>>
>>
>> Hi Sigmund,
>>
>> This doesn't work right: the status field is a bitmask, so multiple bits
>> can be set at the same time. So a switch is not the right choice for tha=
t.
>> Look at some of the other functions to print bitmasks in v4l2-ctl.cpp fo=
r
>> ideas on how to implement this properly.
>>
>> But it will be nice to have this in v4l2-ctl!
> Right, I realized this shortly after sending. I'll take a look at this
> today. However, I'm unsure how to handle the value 0. It seems this is
> used both for "signal detected and everything is ok" and "driver has
> no clue if there is a signal or not". Any feedback welcome.

And again, this time with the attachment.

Best regards

Sigmund Augdal
>
> Best regards
>
> Sigmund Augdal
>>
>> Regards,
>>
>> =A0 =A0 =A0Hans
>>
>> --
>> Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
>>
>>
>

--0015175d0a3c36819804769a529d
Content-Type: application/octet-stream; name="v4l2-ctl-enuminput2.patch"
Content-Disposition: attachment; filename="v4l2-ctl-enuminput2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g14zl4ms0

IyBIRyBjaGFuZ2VzZXQgcGF0Y2gKIyBVc2VyIHJvb3RAbG9jYWxob3N0CiMgRGF0ZSAxMjU2MTMw
ODUyIC0xMDgwMAojIE5vZGUgSUQgMzk0YzRiNzVlNTQ2MzQ0ODNjNTAwMmJmODA0MTI5ZGI4NGNj
OGJlMwojIFBhcmVudCAgZjY2ODBmYThlN2VjODhiYmZiZWRkZGM3YzNlOTkwMDNlMzI4YTFhYQpj
aGFuZ2VkIC0tZ2V0LWlucHV0IHRvIHBhcnNlIGFuZCBvdXRwdXQgdGhlIHN0YXR1cyBmaWVsZCBv
ZiBWSURJT0NfRU5VTUlOUFVUClNpZ25lZC1vZi1ieTogU2lnbXVuZCBBdWdkYWwgPHNpZ211bmRA
c25hcC50dj4KCmRpZmYgLXIgZjY2ODBmYThlN2VjIC1yIDM5NGM0Yjc1ZTU0NiB2NGwyLWFwcHMv
dXRpbC92NGwyLWN0bC5jcHAKLS0tIGEvdjRsMi1hcHBzL3V0aWwvdjRsMi1jdGwuY3BwCVR1ZSBP
Y3QgMjAgMDA6MDg6MDUgMjAwOSArMDkwMAorKysgYi92NGwyLWFwcHMvdXRpbC92NGwyLWN0bC5j
cHAJV2VkIE9jdCAyMSAxNjoxNDoxMiAyMDA5ICswMzAwCkBAIC01NjgsNiArNTY4LDI0IEBAIHN0
YXRpYyBzdGQ6OnN0cmluZyBmbGFnczJzKHVuc2lnbmVkIHZhbCwKIAlyZXR1cm4gczsKIH0KIAor
c3RhdGljIGNvbnN0IGZsYWdfZGVmIHN0YXR1c19kZWZbXSA9IHsKKwl7VjRMMl9JTl9TVF9OT19Q
T1dFUiwiQXR0YWNoZWQgZGV2aWNlIGlzIG9mZi4ifSwKKwl7VjRMMl9JTl9TVF9OT19TSUdOQUws
ICJObyBzaWduYWwifSwKKwl7VjRMMl9JTl9TVF9OT19DT0xPUiwgIlRoZSBoYXJkd2FyZSBzdXBw
b3J0cyBjb2xvciBkZWNvZGluZywgYnV0IGRvZXMgbm90IGRldGVjdCBjb2xvciBtb2R1bGF0aW9u
IGluIHRoZSBzaWduYWwuIn0sCisJe1Y0TDJfSU5fU1RfSEZMSVAsICJUaGUgaW5wdXQgaXMgY29u
bmVjdGVkIHRvIGEgZGV2aWNlIHRoYXQgcHJvZHVjZXMgYSBzaWduYWwgdGhhdCBpcyBmbGlwcGVk
IGhvcml6b250YWxseSBhbmQgZG9lcyBub3QgY29ycmVjdCB0aGlzIGJlZm9yZSBwYXNzaW5nIHRo
ZSBzaWduYWwgdG8gdXNlcnNwYWNlLiJ9LAorCXtWNEwyX0lOX1NUX1ZGTElQLCAiVGhlIGlucHV0
IGlzIGNvbm5lY3RlZCB0byBhIGRldmljZSB0aGF0IHByb2R1Y2VzIGEgc2lnbmFsIHRoYXQgaXMg
ZmxpcHBlZCB2ZXJ0aWNhbGx5IGFuZCBkb2VzIG5vdCBjb3JyZWN0IHRoaXMgYmVmb3JlIHBhc3Np
bmcgdGhlIHNpZ25hbCB0byB1c2Vyc3BhY2UuIE5vdGUgdGhhdCBhIDE4MCBkZWdyZWUgcm90YXRp
b24gaXMgdGhlIHNhbWUgYXMgSEZMSVAgfCBWRkxJUCJ9LAorCXtWNEwyX0lOX1NUX05PX0hfTE9D
SywgIk5vIGhvcml6b250YWwgc3luYyBsb2NrLiJ9LAorCXtWNEwyX0lOX1NUX0NPTE9SX0tJTEws
ICJBIGNvbG9yIGtpbGxlciBjaXJjdWl0IGF1dG9tYXRpY2FsbHkgZGlzYWJsZXMgY29sb3IgZGVj
b2Rpbmcgd2hlbiBpdCBkZXRlY3RzIG5vIGNvbG9yIG1vZHVsYXRpb24uIFdoZW4gdGhpcyBmbGFn
IGlzIHNldCB0aGUgY29sb3Iga2lsbGVyIGlzIGVuYWJsZWQgYW5kIGhhcyBzaHV0IG9mZiBjb2xv
ciBkZWNvZGluZy4ifSwKKwl7VjRMMl9JTl9TVF9OT19TWU5DLCAiTm8gc3luY2hyb25pemF0aW9u
IGxvY2suIn0sCisJe1Y0TDJfSU5fU1RfTk9fRVFVLCAiTm8gZXF1YWxpemVyIGxvY2suIn0sCisJ
e1Y0TDJfSU5fU1RfTk9fQ0FSUklFUiwgIkNhcnJpZXIgcmVjb3ZlcnkgZmFpbGVkLiJ9LAorCXtW
NEwyX0lOX1NUX01BQ1JPVklTSU9OLCAiTWFjcm92aXNpb24gaXMgYW4gYW5hbG9nIGNvcHkgcHJl
dmVudGlvbiBzeXN0ZW0gbWFuZ2xpbmcgdGhlIHZpZGVvIHNpZ25hbCB0byBjb25mdXNlIHZpZGVv
IHJlY29yZGVycy4gV2hlbiB0aGlzIGZsYWcgaXMgc2V0IE1hY3JvdmlzaW9uIGhhcyBiZWVuIGRl
dGVjdGVkLiJ9LAorCXtWNEwyX0lOX1NUX05PX0FDQ0VTUywgIkNvbmRpdGlvbmFsIGFjY2VzcyBk
ZW5pZWQuIn0sCisJe1Y0TDJfSU5fU1RfVlRSLCAiVlRSIHRpbWUgY29uc3RhbnQuIFs/XSJ9LAor
CXswLCBOVUxMfQorfTsKKworCiBzdGF0aWMgdm9pZCBwcmludF9zbGljZWRfdmJpX2NhcChzdHJ1
Y3QgdjRsMl9zbGljZWRfdmJpX2NhcCAmY2FwKQogewogCXByaW50ZigiXHRUeXBlICAgICAgICAg
ICA6ICVzXG4iLCBidWZ0eXBlMnMoY2FwLnR5cGUpLmNfc3RyKCkpOwpAQCAtMjY3MSw2ICsyNjg5
LDExIEBAIHNldF92aWRfZm10X2Vycm9yOgogCQkJaWYgKGlvY3RsKGZkLCBWSURJT0NfRU5VTUlO
UFVULCAmdmluKSA+PSAwKQogCQkJCXByaW50ZigiICglcykiLCB2aW4ubmFtZSk7CiAJCQlwcmlu
dGYoIlxuIik7CisJCQlwcmludGYoIlNpZ25hbCBzdGF0dXM6ICIpOworCQkJaWYgKHZpbi5zdGF0
dXMpCisJCQkJcHJpbnRmKCIlc1xuIiwgZmxhZ3Mycyh2aW4uc3RhdHVzLHN0YXR1c19kZWYpLmNf
c3RyKCkpOworCQkJZWxzZQorCQkJCXByaW50ZigiU2lnbmFsIGRldGVjdGVkIG9yIGRldGVjdGlv
biB1bmF2YWlsYWJsZVxuIik7CiAJCX0KIAl9CiAK
--0015175d0a3c36819804769a529d--
