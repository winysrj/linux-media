Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:60529 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398Ab0CLQUi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Mar 2010 11:20:38 -0500
Received: by fxm19 with SMTP id 19so1330721fxm.21
        for <linux-media@vger.kernel.org>; Fri, 12 Mar 2010 08:20:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B9A6089.4060300@redhat.com>
References: <201003090848.29301.hverkuil@xs4all.nl>
	 <1268197457.3199.17.camel@pc07.localdom.local>
	 <4B98FABB.1040605@gmail.com>
	 <829197381003110631v52410d27m7e13d5438e09cd13@mail.gmail.com>
	 <4B9A6089.4060300@redhat.com>
Date: Fri, 12 Mar 2010 20:20:36 +0400
Message-ID: <1a297b361003120820h768bc388n81077a4b6cfe71e6@mail.gmail.com>
Subject: Re: v4l-utils: i2c-id.h and alevt
From: Manu Abraham <abraham.manu@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	hermann pitton <hermann-pitton@arcor.de>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 12, 2010 at 7:40 PM, Hans de Goede <hdegoede@redhat.com> wrote:
> Hi,
>
> On 03/11/2010 03:31 PM, Devin Heitmueller wrote:
>>
>> On Thu, Mar 11, 2010 at 9:14 AM, Douglas Schilling Landgraf
>> <dougsland@gmail.com>  wrote:
>>>
>>> On 03/10/2010 02:04 AM, hermann pitton wrote:
>>>>
>>>> Hi Hans, both,
>>>>
>>>> Am Dienstag, den 09.03.2010, 08:48 +0100 schrieb Hans Verkuil:
>>>>>
>>>>> It's nice to see this new tree, that should be make it easier to
>>>>> develop
>>>>> utilities!
>>>>>
>>>>> After a quick check I noticed that the i2c-id.h header was copied from
>>>>> the
>>>>> kernel. This is not necessary. The only utility that includes this is
>>>>> v4l2-dbg
>>>>> and that one no longer needs it. Hans, can you remove this?
>>>>>
>>>>> The second question is whether anyone would object if alevt is moved
>>>>> from
>>>>> dvb-apps to v4l-utils? It is much more appropriate to have that tool in
>>>>> v4l-utils.
>>>>
>>>> i wonder that this stays such calm, hopefully a good sign.
>>>>
>>>> In fact alevt analog should come with almost every distribution, but the
>>>> former alevt-dvb, named now only alevt, well, might be ok in some
>>>> future, is enhanced for doing also dvb-t-s and hence there ATM.
>>>>
>>>>> Does anyone know of other unmaintained but useful tools that we might
>>>>> merge
>>>>> into v4l-utils? E.g. xawtv perhaps?
>>>>
>>>> If for xawtv could be some more care, ships also since close to ever
>>>> with alevtd, that would be fine, but I'm not sure we are talking about
>>>> tools anymore in such case, since xawtv4x, tvtime and mpeg4ip ;) for
>>>> example are also there and unmaintained.
>>>>
>>>
>>> I think would be nice to hear a word from Devin, which have been working
>>> in tvtime. Devin?
>>
>> Sorry, I've been sick for the last couple of days and not actively on
>> email.
>>
>> I don't think it's a good idea to consolidate applications like xawtv
>> and tvtime into the v4l2-utils codebase.  The existing v4l2-utils is
>> nice because it's small and what the packages provides what it says it
>> does - v4l2 *utilities*.  I wouldn't consider full blown tv viewing
>> applications to be "utilities".
>>
>> The apps in question are currently packaged by multiple distros today
>> as standalone packages.  Today distros can decide whether they want
>> the "bloat" associated with large GUI applications just to get the
>> benefits of a couple of command line utilities.  Bundling them
>> together makes that much harder (and would also result in a package
>> with lots of external dependencies on third party libraries).
>>
>> Adding them into v4l2-utils doesn't really solve the real problem -
>> that there are very few people willing to put in the effort to
>> extend/improve these applications (something which, as Douglas pointed
>> out, I'm trying to improve in the case of tvtime).
>>
>
> Ack,


ACK

> What would be good to do IMHO is decide for unmaintained apps like xawtv
> and alevt if we want to adopt them and if we do, to create separate git
> trees for them, and become a new upstream including doing regular
> tarbals releases. Some time ago I did a lot of work on the Fedora xawtv
> packages and I would be willing to pull such an effort for xawtv.


Simply creating a tree for an application doesn't really help. At
least it needs a "commitment" to that app to keep it updated. Unless,
someone really puts in such an effort, creating a tree doesn't really
help, it simplyt adds to the confusion for a normal user as to where
he should download his application for his distro, if such a package
doesn't exist.


Regards,
Manu
