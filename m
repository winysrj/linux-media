Return-path: <linux-media-owner@vger.kernel.org>
Received: from acorn.exetel.com.au ([220.233.0.21]:43225 "EHLO
	acorn.exetel.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280AbZKZXgB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 18:36:01 -0500
Message-ID: <46566.64.213.30.2.1259278557.squirrel@webmail.exetel.com.au>
In-Reply-To: <56069.115.70.135.213.1259234530.squirrel@webmail.exetel.com.au>
References: <33305.64.213.30.2.1259216241.squirrel@webmail.exetel.com.au>
    <50104.115.70.135.213.1259224041.squirrel@webmail.exetel.com.au>
    <702870ef0911260137r35f1784exc27498d0db3769c2@mail.gmail.com>
    <56069.115.70.135.213.1259234530.squirrel@webmail.exetel.com.au>
Date: Fri, 27 Nov 2009 10:35:57 +1100 (EST)
Subject: Re: DViCO FusionHDTV DVB-T Dual Digital 4 (rev 1) tuning regression
From: "Robert Lowery" <rglowery@exemail.com.au>
To: "Vincent McIntyre" <vincent.mcintyre@gmail.com>,
	mchehab@redhat.com, terrywu2009@gmail.com, awalls@radix.net
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20091127103557_75135"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

------=_20091127103557_75135
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

>> Hi Rob
>>
>> would you mind very much posting a patch that implements these two
>> reversions,
>> so I can try it easily? My hg-fu is somewhat lacking...
>> I have the same hardware and noticed what I think is the same issue,
>> just with Channel 9.
>> Another manifestation is huge BER and nonzero REC in the output from
>> 'tzap'.
>>
>> Kind regards,
>> Vince
> revert patch attached

My problem was also mostly with Channel 9, but other channels also
exhibited issues, although less often.

Given the original checkin message of
http://linuxtv.org/hg/v4l-dvb/rev/e6a8672631a0 was
"Both ATSC and DVB @ 6MHz bandwidth require the same offset.

While we're fixing it, let's cleanup the bandwidth setup to better
reflect the fact that it is a function of the bandwidth."

How about the attached patch which reverts e6a8672631a0 and 966ce12c444d
but without the "cleanup" which breaks my DViCO.

Could people who had the original 6MHz issue please test and report back

Thanks

-Rob



>
>>
>>
>> On 11/26/09, Robert Lowery <rglowery@exemail.com.au> wrote:
>>>> Hi,
>>>>
>>>> After fixing up a hang on the DViCO FusionHDTV DVB-T Dual Digital 4
>>>> (rev
>>>> 1) recently via http://linuxtv.org/hg/v4l-dvb/rev/1c11cb54f24d
>>>> everything
>>>> appeared to be ok, but I have now noticed certain channels in
>>>> Australia
>>>> are showing corruption which manifest themselves as blockiness and
>>>> screeching audio.
>>>>
>>>> I have traced this issue down to
>>>> http://linuxtv.org/hg/v4l-dvb/rev/e6a8672631a0 (Fix offset frequencies
>>>> for
>>>> DVB @ 6MHz)
>>> Actually, in addition to the above changeset, I also had to revert
>>> http://linuxtv.org/hg/v4l-dvb/rev/966ce12c444d (Fix 7 MHz DVB-T)  to
>>> get
>>> things going.  Seems this one might have been an attempt to fix an
>>> issue
>>> introduced by the latter, but for me both must be reverted.
>>>
>>> -Rob
>>>
>>>>
>>>> In this change, the offset used by my card has been changed from
>>>> 2750000
>>>> to 2250000.
>>>>
>>>> The old code which works used to do something like
>>>> offset = 2750000
>>>> if (((priv->cur_fw.type & DTV7) &&
>>>>     (priv->cur_fw.scode_table & (ZARLINK456 | DIBCOM52))) ||
>>>>     ((priv->cur_fw.type & DTV78) && freq < 470000000))
>>>>     offset -= 500000;
>>>>
>>>> In Australia, (type & DTV7) == true _BUT_ scode_table == 1<<29 ==
>>>> SCODE,
>>>> so the subtraction is not done.
>>>>
>>>> The new code which does not work does
>>>> if (priv->cur_fw.type & DTV7)
>>>>     offset = 2250000;
>>>> which appears to be off by 500khz causing the tuning regression for
>>>> me.
>>>>
>>>> Could any one please advice why this check against scode_table &
>>>> (ZARLINK456 | DIBCOM52) was removed?
>>>>
>>>> Thanks
>>>>
>>>> -Rob
>>>>
>>>>
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-media"
>>>> in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media"
>>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>

------=_20091127103557_75135
Content-Type: /; name="revert2.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="revert2.diff"

ZGlmZiAtciAzMmIyYTE4NzU3NTIgbGludXgvZHJpdmVycy9tZWRpYS9jb21tb24vdHVuZXJzL3R1
bmVyLXhjMjAyOC5jCi0tLSBhL2xpbnV4L2RyaXZlcnMvbWVkaWEvY29tbW9uL3R1bmVycy90dW5l
ci14YzIwMjguYwlGcmkgTm92IDIwIDEyOjQ3OjQwIDIwMDkgKzAxMDAKKysrIGIvbGludXgvZHJp
dmVycy9tZWRpYS9jb21tb24vdHVuZXJzL3R1bmVyLXhjMjAyOC5jCUZyaSBOb3YgMjcgMTA6Mjk6
MjIgMjAwOSArMTEwMApAQCAtOTM0LDI5ICs5MzQsMjMgQEAKIAkgKiB0aGF0IHhjMjAyOCB3aWxs
IGJlIGluIGEgc2FmZSBzdGF0ZS4KIAkgKiBNYXliZSB0aGlzIG1pZ2h0IGFsc28gYmUgbmVlZGVk
IGZvciBEVFYuCiAJICovCi0JaWYgKG5ld19tb2RlID09IFRfQU5BTE9HX1RWKQorCWlmIChuZXdf
bW9kZSA9PSBUX0FOQUxPR19UVikgewogCQlyYyA9IHNlbmRfc2VxKHByaXYsIHsweDAwLCAweDAw
fSk7Ci0KLQkvKgotCSAqIERpZ2l0YWwgbW9kZXMgcmVxdWlyZSBhbiBvZmZzZXQgdG8gYWRqdXN0
IHRvIHRoZQotCSAqIHByb3BlciBmcmVxdWVuY3kuCi0JICogQW5hbG9nIG1vZGVzIHJlcXVpcmUg
b2Zmc2V0ID0gMAotCSAqLwotCWlmIChuZXdfbW9kZSA9PSBUX0RJR0lUQUxfVFYpIHsKLQkJLyog
U2V0cyB0aGUgb2Zmc2V0IGFjY29yZGluZyB3aXRoIGZpcm13YXJlICovCi0JCWlmIChwcml2LT5j
dXJfZncudHlwZSAmIERUVjYpCi0JCQlvZmZzZXQgPSAxNzUwMDAwOwotCQllbHNlIGlmIChwcml2
LT5jdXJfZncudHlwZSAmIERUVjcpCi0JCQlvZmZzZXQgPSAyMjUwMDAwOwotCQllbHNlCS8qIERU
Vjggb3IgRFRWNzggKi8KLQkJCW9mZnNldCA9IDI3NTAwMDA7Ci0KKwl9IGVsc2UgaWYgKHByaXYt
PmN1cl9mdy50eXBlICYgRFRWNikgeworCQlvZmZzZXQgPSAxNzUwMDAwOworCX0gZWxzZSB7CisJ
CW9mZnNldCA9IDI3NTAwMDA7CisJCiAJCS8qCi0JCSAqIFdlIG11c3QgYWRqdXN0IHRoZSBvZmZz
ZXQgYnkgNTAwa0h6ICB3aGVuCi0JCSAqIHR1bmluZyBhIDdNSHogVkhGIGNoYW5uZWwgd2l0aCBE
VFY3OCBmaXJtd2FyZQotCQkgKiAodXNlZCBpbiBBdXN0cmFsaWEsIEl0YWx5IGFuZCBHZXJtYW55
KQorCQkgKiBXZSBtdXN0IGFkanVzdCB0aGUgb2Zmc2V0IGJ5IDUwMGtIeiBpbiB0d28gY2FzZXMg
aW4gb3JkZXIKKwkJICogdG8gY29ycmVjdGx5IGNlbnRlciB0aGUgSUYgb3V0cHV0OgorCQkgKiAx
KSBXaGVuIHRoZSBaQVJMSU5LNDU2IG9yIERJQkNPTTUyIHRhYmxlcyB3ZXJlIGV4cGxpY2l0bHkK
KwkJICogICAgc2VsZWN0ZWQgYW5kIGEgN01IeiBjaGFubmVsIGlzIHR1bmVkOworCQkgKiAyKSBX
aGVuIHR1bmluZyBhIFZIRiBjaGFubmVsIHdpdGggRFRWNzggZmlybXdhcmUuCiAJCSAqLwotCQlp
ZiAoKHByaXYtPmN1cl9mdy50eXBlICYgRFRWNzgpICYmIGZyZXEgPCA0NzAwMDAwMDApCisJCWlm
ICgoKHByaXYtPmN1cl9mdy50eXBlICYgRFRWNykgJiYKKwkJICAgICAocHJpdi0+Y3VyX2Z3LnNj
b2RlX3RhYmxlICYgKFpBUkxJTks0NTYgfCBESUJDT001MikpKSB8fAorCQkgICAgKChwcml2LT5j
dXJfZncudHlwZSAmIERUVjc4KSAmJiBmcmVxIDwgNDcwMDAwMDAwKSkKIAkJCW9mZnNldCAtPSA1
MDAwMDA7CiAJfQogCkBAIC0xMTE0LDE5ICsxMTA4LDggQEAKIAl9CiAKIAkvKiBBbGwgUy1jb2Rl
IHRhYmxlcyBuZWVkIGEgMjAwa0h6IHNoaWZ0ICovCi0JaWYgKHByaXYtPmN0cmwuZGVtb2QpIHsK
KwlpZiAocHJpdi0+Y3RybC5kZW1vZCkKIAkJZGVtb2QgPSBwcml2LT5jdHJsLmRlbW9kICsgMjAw
OwotCQkvKgotCQkgKiBUaGUgRFRWNyBTLWNvZGUgdGFibGUgbmVlZHMgYSA3MDAga0h6IHNoaWZ0
LgotCQkgKiBUaGFua3MgdG8gVGVycnkgV3UgPHRlcnJ5d3UyMDA5QGdtYWlsLmNvbT4gZm9yIHJl
cG9ydGluZyB0aGlzCi0JCSAqCi0JCSAqIERUVjcgaXMgb25seSB1c2VkIGluIEF1c3RyYWxpYS4g
IEdlcm1hbnkgb3IgSXRhbHkgbWF5IGFsc28KLQkJICogdXNlIHRoaXMgZmlybXdhcmUgYWZ0ZXIg
aW5pdGlhbGl6YXRpb24sIGJ1dCBhIHR1bmUgdG8gYSBVSEYKLQkJICogY2hhbm5lbCBzaG91bGQg
dGhlbiBjYXVzZSBEVFY3OCB0byBiZSB1c2VkLgotCQkgKi8KLQkJaWYgKHR5cGUgJiBEVFY3KQot
CQkJZGVtb2QgKz0gNTAwOwotCX0KIAogCXJldHVybiBnZW5lcmljX3NldF9mcmVxKGZlLCBwLT5m
cmVxdWVuY3ksCiAJCQkJVF9ESUdJVEFMX1RWLCB0eXBlLCAwLCBkZW1vZCk7Cg==
------=_20091127103557_75135--


