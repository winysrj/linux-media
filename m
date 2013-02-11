Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757101Ab3BKNFt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Feb 2013 08:05:49 -0500
Message-ID: <5118ED5C.2080801@redhat.com>
Date: Mon, 11 Feb 2013 14:08:44 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 01/12] stk-webcam: the initial hflip and vflip setup
 was the wrong way around
References: <1360518773-1065-1-git-send-email-hverkuil@xs4all.nl> <21a2f157a80755483630be6aab26f67dc9f041c6.1360518390.git.hans.verkuil@cisco.com>
In-Reply-To: <21a2f157a80755483630be6aab26f67dc9f041c6.1360518390.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Subject: stk-webcam: the initial hflip and vflip setup was the wrong way around

No it is not.

On 02/10/2013 06:52 PM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> This resulted in an upside-down picture.

No it does not, the laptop having an upside down mounted camera and not being
in the dmi-table is what causes an upside down picture. For a non upside
down camera (so no dmi-match) hflip and vflip should be 0.

The fix for the upside-down-ness Arvydas Sidorenko reported would be to
add his laptop to the upside down table.

Regards,

Hans
