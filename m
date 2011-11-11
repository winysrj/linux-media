Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38918 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab1KKG0d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Nov 2011 01:26:33 -0500
Received: by wwe5 with SMTP id 5so846703wwe.1
        for <linux-media@vger.kernel.org>; Thu, 10 Nov 2011 22:26:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EBC402E.20208@redhat.com>
References: <CAHFNz9Lf8CXb2pqmO0669VV2HAqxCpM9mmL9kU=jM19oNp0dbg@mail.gmail.com>
	<4EBBE336.8050501@linuxtv.org>
	<CAHFNz9JNLAFnjd14dviJJDKcN3cxgB+MFrZ72c1MVXPLDsuT0Q@mail.gmail.com>
	<4EBC402E.20208@redhat.com>
Date: Fri, 11 Nov 2011 11:56:31 +0530
Message-ID: <CAHFNz9KFv7XvK4Uafuk8UDZiu1GEHSZ8bUp3nAyM21ck09yOCQ@mail.gmail.com>
Subject: Re: PATCH: Query DVB frontend capabilities
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andreas Oberritter <obi@linuxtv.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Steven Toth <stoth@kernellabs.com>
Content-Type: multipart/mixed; boundary=00504502c64c18417e04b16f9ad0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--00504502c64c18417e04b16f9ad0
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Nov 11, 2011 at 2:50 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 10-11-2011 13:30, Manu Abraham escreveu:
>> Hi Andreas,
>>
>> On Thu, Nov 10, 2011 at 8:14 PM, Andreas Oberritter <obi@linuxtv.org> wrote:
>>> Hello Manu,
>>>
>>> please see my comments below:
>>>
>>> On 10.11.2011 15:18, Manu Abraham wrote:
>>>> Hi,
>>>>
>>>> Currently, for a multi standard frontend it is assumed that it just
>>>> has a single standard capability. This is fine in some cases, but
>>>> makes things hard when there are incompatible standards in conjuction.
>>>> Eg: DVB-S can be seen as a subset of DVB-S2, but the same doesn't hold
>>>> the same for DSS. This is not specific to any driver as it is, but a
>>>> generic issue. This was handled correctly in the multiproto tree,
>>>> while such functionality is missing from the v5 API update.
>>>>
>>>> http://www.linuxtv.org/pipermail/vdr/2008-November/018417.html
>>>>
>>>> Later on a FE_CAN_2G_MODULATION was added as a hack to workaround this
>>>> issue in the v5 API, but that hack is incapable of addressing the
>>>> issue, as it can be used to simply distinguish between DVB-S and
>>>> DVB-S2 alone, or another x vs X2 modulation. If there are more
>>>> systems, then you have a potential issue.
>
> For sure something like that is needed.
>
> DVB TURBO is another example where the FE_CAN_2G_MODULATION approach doesn't
> properly address.
>


It is similar to a DVB-S system with a different modulation and FEC.
It was specifically designed to make it proprietary. Nothing wrong
with it as it is now.


>>>>
>>>> In addition to the patch, for illustrative purposes the stb0899 driver
>>>> is depicted providing the said capability information.
>>>>
>>>> An application needs to query the device capabilities before
>>>> requesting an operation from the device.
>>>>
>>>> If people don't have any objections, Probably other drivers can be
>>>> adapted similarly. In fact the change is quite simple.
>>>>
>>>> Comments ?
>>>>
>>>> Regards,
>>>> Manu
>>>>
>>>>
>>>> query_frontend_capabilities.diff
>>>>
>>>>
>>>> diff -r b6eb04718aa9 linux/drivers/media/dvb/dvb-core/dvb_frontend.c
>>>> --- a/linux/drivers/media/dvb/dvb-core/dvb_frontend.c Wed Nov 09 19:52:36 2011 +0530
>>>> +++ b/linux/drivers/media/dvb/dvb-core/dvb_frontend.c Thu Nov 10 13:51:35 2011 +0530
>>>> @@ -973,6 +973,8 @@
>>>>       _DTV_CMD(DTV_GUARD_INTERVAL, 0, 0),
>>>>       _DTV_CMD(DTV_TRANSMISSION_MODE, 0, 0),
>>>>       _DTV_CMD(DTV_HIERARCHY, 0, 0),
>>>> +
>>>> +     _DTV_CMD(DTV_DELIVERY_CAPS, 0, 0),
>>>>  };
>>>>
>>>>  static void dtv_property_dump(struct dtv_property *tvp)
>>>> @@ -1226,7 +1228,18 @@
>>>>               c = &cdetected;
>>>>       }
>>>>
>>>> +     dprintk("%s\n", __func__);
>>>> +
>>>>       switch(tvp->cmd) {
>>>> +     case DTV_DELIVERY_CAPS:
>>>> +             if (fe->ops.delivery_caps) {
>>>> +                     r = fe->ops.delivery_caps(fe, tvp);
>>>> +                     if (r < 0)
>>>> +                             return r;
>>>> +                     else
>>>> +                             goto done;
>>>
>>> What's the reason for introducing that label and goto?
>>
>>
>> The idea was to avoid using get_property callback being called.
>
> Nothing warrants that the only property will be DTV_DELIVERY_CAPS.
> calling get_property callback will likely work better.

It is indeed called within a case switch:
+	case DTV_DELIVERY_CAPS:
+		if (fe->ops.delivery_caps) {
+			r = fe->ops.delivery_caps(fe, tvp);

So, It does warrant that delivery caps are filled only with the
DTV_DELIVERY_CAPS, just like any other command, no difference in
there. But as I stated earlier, using get_property is just as fine.


>>
>>
>>
>>>
>>>> +             }
>>>> +             break;
>>>>       case DTV_FREQUENCY:
>>>>               tvp->u.data = c->frequency;
>>>>               break;
>>>> @@ -1350,7 +1363,7 @@
>>>>               if (r < 0)
>>>>                       return r;
>>>>       }
>>>> -
>>>> +done:
>>>>       dtv_property_dump(tvp);
>>>>
>>>>       return 0;
>>>> diff -r b6eb04718aa9 linux/drivers/media/dvb/dvb-core/dvb_frontend.h
>>>> --- a/linux/drivers/media/dvb/dvb-core/dvb_frontend.h Wed Nov 09 19:52:36 2011 +0530
>>>> +++ b/linux/drivers/media/dvb/dvb-core/dvb_frontend.h Thu Nov 10 13:51:35 2011 +0530
>>>> @@ -305,6 +305,8 @@
>>>>
>>>>       int (*set_property)(struct dvb_frontend* fe, struct dtv_property* tvp);
>>>>       int (*get_property)(struct dvb_frontend* fe, struct dtv_property* tvp);
>>>> +
>>>> +     int (*delivery_caps)(struct dvb_frontend *fe, struct dtv_property *tvp);
>>>>  };
>>>
>>> I don't think that another function pointer is required. Drivers can
>>> implement this in their get_property callback. The core could provide a
>>> default implementation, returning values derived from fe->ops.info.type
>>> and the 2G flag.
>>
>>
>> I see your point. While trying to address the issue I had originally
>> get_property being used. One Issue that came across to me was that:
>>
>>  - while currently this is just one capability field, things do look
>> fine. As we move ahead we will possibly have more capability related
>> information, given the idea that with shared hardware infrastructure
>> on frontends, this list of properties could grow.
>
> There are two DVBv5 calls that are likely designed to address this
> need:
>        DTV_FE_CAPABILITY_COUNT
>        DTV_FE_CAPABILITY
>
> Unfortunately, those were never implemented. I _suspect_ that the original
> idea were to allow passing an arbritary count to the driver, and let it fill
> each capability.


This was likely meant to be used for the FE_CAN flags as far as I can
see. This is not what I am trying to address.


>
>> - Once we have a few properties, then we will need to have switches in
>> that callback, given that it is generic and that length will grow.
>> Considering different hardware capabilities, we will have quite a bit
>> of shared code amongst drivers in that large switch, causing code
>> duplication.
>> Eg: with hardware having shared infrastructure - while globally it
>> might have a larger set of capabilities, when a sub part of it is run
>> in some mode, the other sub parts would have reduced set of
>> capabilities, which won't be the same as that exists globally for the
>> device. The driver alone will know the change depending on what's
>> being used.
>>
>>
>> - Additionally, though insignificant a separate callback for each
>> capability will make the drivers look a bit more consistent with
>> regards to code style.
>>
>> The basic issue is a switch that will be duplicated across drivers and
>> that which is expected to grow in length, eventually readability a
>> question. That said, this shouldn't be an issue at all. Given the
>> situation at this exact moment, having a generic callback is just
>> fine, as that will be the only which would be there, right now.
>>
>>
>>>
>>>>  #define MAX_EVENT 8
>>>> @@ -362,6 +364,8 @@
>>>>
>>>>       /* DVB-T2 specifics */
>>>>       u32                     dvbt2_plp_id;
>>>> +
>>>> +     fe_delivery_system_t    delivery_caps[32];
>>>>  };
>>>
>>> This array seems to be unused.
>>
>>
>> That just walked in astray while I worked on it. Didn't notice at all. :-)
>> I will send an updated patch, do you still think the generic callback
>> is better ?
>>
>>
>>
>>>
>>> Regards,
>>> Andreas
>>>
>>>>  struct dvb_frontend {
>>>> diff -r b6eb04718aa9 linux/drivers/media/dvb/frontends/stb0899_drv.c
>>>> --- a/linux/drivers/media/dvb/frontends/stb0899_drv.c Wed Nov 09 19:52:36 2011 +0530
>>>> +++ b/linux/drivers/media/dvb/frontends/stb0899_drv.c Thu Nov 10 13:51:35 2011 +0530
>>>> @@ -1605,6 +1605,19 @@
>>>>       return DVBFE_ALGO_CUSTOM;
>>>>  }
>>>>
>>>> +static int stb0899_delivery_caps(struct dvb_frontend *fe, struct dtv_property *caps)
>>>> +{
>>>> +     struct stb0899_state *state             = fe->demodulator_priv;
>>>> +
>>>> +     dprintk(state->verbose, FE_DEBUG, 1, "Get caps");
>>>> +     caps->u.buffer.data[0] = SYS_DSS;
>>>> +     caps->u.buffer.data[1] = SYS_DVBS;
>>>> +     caps->u.buffer.data[2] = SYS_DVBS2;
>>>> +     caps->u.buffer.len = 3;
>
> This doesn't sound right to me. If userspace passed space for only one delivery system,
> you can't just adjust the size here and expect it to work, as the array on userspace
> may be smaller than 3 properties.


You misunderstood.

The userspace requested just a single property, not more than that.
The usage at the kernel side is also for a single property.

This would be what would be running at userspace for the specified patch.

struct dtv_property p[] = {
    { .cmd = DTV_DELIVERY_CAPS },
}

struct dtv_properties cmd = {
     .num = 1,
     .props = p,
}

ioctl(fd, FE_GET_PROPERTY, &cmd);

> Also, the other DVBv5 properties may not be DTV_DELIVERY_CAPS type.
>
> In other words, the driver or core needs to check if the type is DTV_DELIVERY_CAPS
> before filling it.


It is indeed called within a case switch:
+	case DTV_DELIVERY_CAPS:
+		if (fe->ops.delivery_caps) {
+			r = fe->ops.delivery_caps(fe, tvp);


So, It does warrant that delivery caps are filled only with the
DTV_DELIVERY_CAPS, just like any other command, no difference in
there. But as I stated earlier, using get_property is just as fine.


>
> Btw, if the "capabilities" here is just the delivery system, it would be better to
> name it as something like DTV_GET_SUPPORTED_DELIVERY.


Yes that's the intention. But I would like to have a shorter name.
First of all the GET in there is superfluous as it is used in a
FE_GET_PROPERTY. Also you cannot SET from userspace a
SUPPORTED_DELIVERY. Do you feel much of a difference between
DTV_DELIVERY_CAPS and DTV_SUPPORTED_DELIVERY ? It's just a naming
issue. I can live with either of them, but still feel that
DTV_DELIVERY_CAPS is a bit more relevant.

>
> We should also think on a way to enumerate the supported values for each DVB properties,
> the enum fe_caps is not enough anymore to store everything. It currently has 30 bits
> filled (of a total of 32 bits), and we currently have:
>        12 code rates (including AUTO/NONE);
>        13 modulation types;
>        7 transmission modes;
>        7 bandwidths;
>        8 guard intervals (including AUTO);
>        5 hierarchy names;
>        4 rolloff's (probably, we'll need to add 2 more, to distinguish between DVB-C Annex A and Annex C).

These parameters aren't anything related to the current patch.

>
> So, if we would need to add one CAN_foo for each of the above, we would need 56 to 58
> bits, plus 5-6 bits to the other capabilities that currently exists there. So, even
> 64 bits won't be enough for the current needs (even having the delivery system caps
> addressed by something else).
>
> It means that FE_GET_INFO needs to be replaced by something that scales better, e. g.
> that would allow to enumerate the supported ranges for each DVBv5 parameter.


This is not what I am addressing. This is outside the scope of the
proposed patch and requirement. These flags are retrieved correctly as
of now and is used without any issues. The purpose of the patch is to
query DVB delivery system capabilities alone, rather than DVB frontend
info/capability.

Attached is a revised version 2 of the patch, which addresses the
issues that were raised.


Regards,
Manu

--00504502c64c18417e04b16f9ad0
Content-Type: text/x-patch; charset=US-ASCII; name="query_frontend_capabilities-v2.diff"
Content-Disposition: attachment;
	filename="query_frontend_capabilities-v2.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

ZGlmZiAtciBiNmViMDQ3MThhYTkgbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZHZiLWNvcmUvZHZi
X2Zyb250ZW5kLmMKLS0tIGEvbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZHZiLWNvcmUvZHZiX2Zy
b250ZW5kLmMJV2VkIE5vdiAwOSAxOTo1MjozNiAyMDExICswNTMwCisrKyBiL2xpbnV4L2RyaXZl
cnMvbWVkaWEvZHZiL2R2Yi1jb3JlL2R2Yl9mcm9udGVuZC5jCUZyaSBOb3YgMTEgMDY6MDU6NDAg
MjAxMSArMDUzMApAQCAtOTczLDYgKzk3Myw4IEBACiAJX0RUVl9DTUQoRFRWX0dVQVJEX0lOVEVS
VkFMLCAwLCAwKSwKIAlfRFRWX0NNRChEVFZfVFJBTlNNSVNTSU9OX01PREUsIDAsIDApLAogCV9E
VFZfQ01EKERUVl9ISUVSQVJDSFksIDAsIDApLAorCisJX0RUVl9DTUQoRFRWX0RFTElWRVJZX0NB
UFMsIDAsIDApLAogfTsKIAogc3RhdGljIHZvaWQgZHR2X3Byb3BlcnR5X2R1bXAoc3RydWN0IGR0
dl9wcm9wZXJ0eSAqdHZwKQpAQCAtMTIyNiw3ICsxMjI4LDExIEBACiAJCWMgPSAmY2RldGVjdGVk
OwogCX0KIAorCWRwcmludGsoIiVzXG4iLCBfX2Z1bmNfXyk7CisKIAlzd2l0Y2godHZwLT5jbWQp
IHsKKwljYXNlIERUVl9ERUxJVkVSWV9DQVBTOgorCQlicmVhazsKIAljYXNlIERUVl9GUkVRVUVO
Q1k6CiAJCXR2cC0+dS5kYXRhID0gYy0+ZnJlcXVlbmN5OwogCQlicmVhazsKQEAgLTEzNTAsNyAr
MTM1Niw3IEBACiAJCWlmIChyIDwgMCkKIAkJCXJldHVybiByOwogCX0KLQorZG9uZToKIAlkdHZf
cHJvcGVydHlfZHVtcCh0dnApOwogCiAJcmV0dXJuIDA7CmRpZmYgLXIgYjZlYjA0NzE4YWE5IGxp
bnV4L2RyaXZlcnMvbWVkaWEvZHZiL2Zyb250ZW5kcy9zdGIwODk5X2Rydi5jCi0tLSBhL2xpbnV4
L2RyaXZlcnMvbWVkaWEvZHZiL2Zyb250ZW5kcy9zdGIwODk5X2Rydi5jCVdlZCBOb3YgMDkgMTk6
NTI6MzYgMjAxMSArMDUzMAorKysgYi9saW51eC9kcml2ZXJzL21lZGlhL2R2Yi9mcm9udGVuZHMv
c3RiMDg5OV9kcnYuYwlGcmkgTm92IDExIDA2OjA1OjQwIDIwMTEgKzA1MzAKQEAgLTE2MDUsNiAr
MTYwNSwyMiBAQAogCXJldHVybiBEVkJGRV9BTEdPX0NVU1RPTTsKIH0KIAorc3RhdGljIGludCBz
dGIwODk5X2dldF9wcm9wZXJ0eShzdHJ1Y3QgZHZiX2Zyb250ZW5kICpmZSwgc3RydWN0IGR0dl9w
cm9wZXJ0eSAqcCkKK3sKKwlzd2l0Y2ggKHAtPmNtZCkgeworCWNhc2UgRFRWX0RFTElWRVJZX0NB
UFM6CisJCXAtPnUuYnVmZmVyLmRhdGFbMF0gPSBTWVNfRFNTOworCQlwLT51LmJ1ZmZlci5kYXRh
WzFdID0gU1lTX0RWQlM7CisJCXAtPnUuYnVmZmVyLmRhdGFbMl0gPSBTWVNfRFZCUzI7CisJCXAt
PnUuYnVmZmVyLmxlbiA9IDM7CisJCWJyZWFrOworCWRlZmF1bHQ6CisJCXJldHVybiAtRUlOVkFM
OworCX0KKwlyZXR1cm4gMDsKK30KKworCiBzdGF0aWMgc3RydWN0IGR2Yl9mcm9udGVuZF9vcHMg
c3RiMDg5OV9vcHMgPSB7CiAKIAkuaW5mbyA9IHsKQEAgLTE2NDcsNiArMTY2Myw4IEBACiAJLmRp
c2VxY19zZW5kX21hc3Rlcl9jbWQJCT0gc3RiMDg5OV9zZW5kX2Rpc2VxY19tc2csCiAJLmRpc2Vx
Y19yZWN2X3NsYXZlX3JlcGx5CT0gc3RiMDg5OV9yZWN2X3NsYXZlX3JlcGx5LAogCS5kaXNlcWNf
c2VuZF9idXJzdAkJPSBzdGIwODk5X3NlbmRfZGlzZXFjX2J1cnN0LAorCisJLmdldF9wcm9wZXJ0
eQkJCT0gc3RiMDg5OV9nZXRfcHJvcGVydHksCiB9OwogCiBzdHJ1Y3QgZHZiX2Zyb250ZW5kICpz
dGIwODk5X2F0dGFjaChzdHJ1Y3Qgc3RiMDg5OV9jb25maWcgKmNvbmZpZywgc3RydWN0IGkyY19h
ZGFwdGVyICppMmMpCmRpZmYgLXIgYjZlYjA0NzE4YWE5IGxpbnV4L2luY2x1ZGUvbGludXgvZHZi
L2Zyb250ZW5kLmgKLS0tIGEvbGludXgvaW5jbHVkZS9saW51eC9kdmIvZnJvbnRlbmQuaAlXZWQg
Tm92IDA5IDE5OjUyOjM2IDIwMTEgKzA1MzAKKysrIGIvbGludXgvaW5jbHVkZS9saW51eC9kdmIv
ZnJvbnRlbmQuaAlGcmkgTm92IDExIDA2OjA1OjQwIDIwMTEgKzA1MzAKQEAgLTMxNiw3ICszMTYs
OSBAQAogCiAjZGVmaW5lIERUVl9EVkJUMl9QTFBfSUQJNDMKIAotI2RlZmluZSBEVFZfTUFYX0NP
TU1BTkQJCQkJRFRWX0RWQlQyX1BMUF9JRAorI2RlZmluZSBEVFZfREVMSVZFUllfQ0FQUwk0NAor
CisjZGVmaW5lIERUVl9NQVhfQ09NTUFORAkJCQlEVFZfREVMSVZFUllfQ0FQUwogCiB0eXBlZGVm
IGVudW0gZmVfcGlsb3QgewogCVBJTE9UX09OLAo=
--00504502c64c18417e04b16f9ad0--
