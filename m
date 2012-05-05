Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446Ab2EEOqf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 May 2012 10:46:35 -0400
Message-ID: <4FA53D48.6020004@redhat.com>
Date: Sat, 05 May 2012 16:46:32 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 1/7] gspca: allow subdrivers to use the control
 framework.
References: <1335625796-9429-1-git-send-email-hverkuil@xs4all.nl> <ea7e986dc0fa18da12c22048e9187e9933191d3d.1335625085.git.hans.verkuil@cisco.com> <4FA4DA05.5030001@redhat.com> <201205051034.30484.hverkuil@xs4all.nl>
In-Reply-To: <201205051034.30484.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 05/05/2012 10:34 AM, Hans Verkuil wrote:
> On Sat May 5 2012 09:43:01 Hans de Goede wrote:
>> Hi,
>>
>> I'm slowly working my way though this series today (both review, as well
>> as some tweaks and testing).
>
> Thanks for that!
>
> One note: I initialized the controls in sd_init. That's wrong, it should be
> sd_config. sd_init is also called on resume, so that would initialize the
> controls twice.

You cannot move the initializing of the controls to sd_config, since in many
cases the sensor probing is done in sd_init, and we need to know the sensor
type to init the controls. I suggest that instead you give the sd_init
function a resume parameter and only init the controls if the resume parameter
is false.

> I'm working on this as well today, together with finishing the stv06xx and
> mars conversion.

Cool!

Regards,

Hans
