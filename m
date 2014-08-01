Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:44897 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756178AbaHAUux (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Aug 2014 16:50:53 -0400
In-Reply-To: <53DBB346.5060205@iki.fi>
References: <1406730195-64365-1-git-send-email-hverkuil@xs4all.nl> <1406730195-64365-3-git-send-email-hverkuil@xs4all.nl> <1406834177.1912.25.camel@palomino.walls.org> <53DB6877.1070001@xs4all.nl> <20140801171957.fe3359ee5a03f7d512de2027@ao2.it> <53DBB346.5060205@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCHv1 02/12] vivid.txt: add documentation for the vivid driver.
From: Andy Walls <awalls@md.metrocast.net>
Date: Fri, 01 Aug 2014 16:50:29 -0400
To: Antti Palosaari <crope@iki.fi>, Antonio Ospite <ao2@ao2.it>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Message-ID: <e9b0c8e0-89c7-455c-a1fd-422be97e5b0e@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On August 1, 2014 11:33:26 AM EDT, Antti Palosaari <crope@iki.fi> wrote:
>
>
>On 08/01/2014 06:19 PM, Antonio Ospite wrote:
>> On Fri, 01 Aug 2014 12:14:15 +0200
>> Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>
>>> On 07/31/2014 09:16 PM, Andy Walls wrote:
>>>> On Wed, 2014-07-30 at 16:23 +0200, Hans Verkuil wrote:
>>>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>>>
>> [..]
>>>>> +- Improve the sinus generation of the SDR radio.
>>>>
>>>> Maybe a lookup table, containing the first quarter wave of cos()
>from 0
>>>> to pi/2 in pi/200 steps, and then linear interpolation for cos() of
>>>> angles in between those steps.  You could go with a larger lookup
>table
>>>> with finer grained steps to reduce the approximation errors.  A
>lookup
>>>> table with linear interpolation, I would think, requires fewer
>>>> mutliplies and divides than the current Taylor expansion
>computation.
>>>
>>> Yeah, I had plans for that. There actually is a sine-table already
>in vivid-tpg.c
>>> since I'm using that to implement Hue support.
>>>
>>
>> I don't know what your requirements are here but JFTR there is
>already a
>> simplistic implementation of fixed point operations in
>> include/linux/fixp-arith.h I used them in
>> drivers/media/usb/gspca/ov534.c for some hue calculation.
>
>I looked that too, but there was very small LUT => very bad resolution.
>
>So I ended up copying sin/cos from cx88 driver (Taylor method).
>
>regards
>Antti

I was thinking of implementing a fixed point sine based on the quintic polynomial approximation of sin (pi/2 * x) described here:

http://www.coranac.com/2009/07/sines/

since I wanted to learn fixed point stuff anyway.

But probably -ENOTIME .

Regards,
Andy
