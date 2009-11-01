Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:53986 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422AbZKAHwe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Nov 2009 02:52:34 -0500
Date: Sun, 1 Nov 2009 09:52:59 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>,
	Thomas Kaiser <thomas@kaiser-linux.li>,
	Theodore Kilgore <kilgota@auburn.edu>,
	Kyle Guinn <elyk03@gmail.com>
Subject: Re: [PATCH 00/21] gspca pac7302/pac7311: separate the two drivers
Message-ID: <20091101095259.67122ef1@tele>
In-Reply-To: <4AECC486.7080404@freemail.hu>
References: <4AECC486.7080404@freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 01 Nov 2009 00:13:10 +0100
Németh Márton <nm127@freemail.hu> wrote:

> the following patchset refactores the Pixart PAC7311 subdriver. The
> current situation is that the code contains a lot of decisions
> like this:
> 
>     if (sd->sensor == SENSOR_PAC7302) {
>         ... do this ...
>     } else {
>         ... do something else ...
>     }
> 
> The sensor type is determined using the USB Vendor ID and Product
> ID which means that the decisions shown are not really necessary.
> 
> The goal of the patchset is to have a PAC7302 and a PAC7311 subdriver
> which have the benefit that there is no decision necessary on sensor
> type at runtime. The common functions can be extracted later but this
> would be a different patchset.

Hello Márton,

Splitting the pac7311 subdriver is a good idea, but I don't like your
patchset: a lot of changes (function prefixes) are nullified by the
last patch. I'd better like only one change for the pac7302 creation
and a second one for the interface change of pac_find_sof() in
pac_common.h (BTW, this file could now be compiled separately).

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
