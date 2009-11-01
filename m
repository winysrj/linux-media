Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:55055 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbZKAV7J (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Nov 2009 16:59:09 -0500
Message-ID: <4AEE04AA.1040308@freemail.hu>
Date: Sun, 01 Nov 2009 22:59:06 +0100
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>,
	Thomas Kaiser <thomas@kaiser-linux.li>,
	Theodore Kilgore <kilgota@auburn.edu>,
	Kyle Guinn <elyk03@gmail.com>
Subject: Re: [PATCH 00/21] gspca pac7302/pac7311: separate the two drivers
References: <4AECC486.7080404@freemail.hu> <20091101095259.67122ef1@tele>
In-Reply-To: <20091101095259.67122ef1@tele>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jean-Francois Moine wrote:
> On Sun, 01 Nov 2009 00:13:10 +0100
> Németh Márton <nm127@freemail.hu> wrote:
> 
>> the following patchset refactores the Pixart PAC7311 subdriver. The
>> current situation is that the code contains a lot of decisions
>> like this:
>>
>>     if (sd->sensor == SENSOR_PAC7302) {
>>         ... do this ...
>>     } else {
>>         ... do something else ...
>>     }
>>
>> The sensor type is determined using the USB Vendor ID and Product
>> ID which means that the decisions shown are not really necessary.
>>
>> The goal of the patchset is to have a PAC7302 and a PAC7311 subdriver
>> which have the benefit that there is no decision necessary on sensor
>> type at runtime. The common functions can be extracted later but this
>> would be a different patchset.
> 
> Splitting the pac7311 subdriver is a good idea, but I don't like your
> patchset: a lot of changes (function prefixes) are nullified by the
> last patch. I'd better like only one change for the pac7302 creation
> and a second one for the interface change of pac_find_sof() in
> pac_common.h (BTW, this file could now be compiled separately).

Hello Jef,

thank you for the feedback, I'll try to send a patch set wich contains
bigger steps. I hope the separation will be not a too big step and won't
make it too difficult to bisect any possible problem I might introduce
with this change. But hope for the best and imagine the easy way when
no regression was introduced.

I am also thinking about finding the common functions which can be
compiled separately either in a helper module or to gspca_main maybe.
But first I focus on the pac7302/pac7311 separation.

	Márton Németh
