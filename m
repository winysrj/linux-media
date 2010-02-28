Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:33640 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936525Ab0B1T1n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Feb 2010 14:27:43 -0500
Date: Sun, 28 Feb 2010 20:28:01 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
Cc: Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/3] add feedback LED control
Message-ID: <20100228202801.6986cb19@tele>
In-Reply-To: <4B8A2158.6020701@freemail.hu>
References: <4B8A2158.6020701@freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 28 Feb 2010 08:55:04 +0100
Németh Márton <nm127@freemail.hu> wrote:

> On some webcams a feedback LED can be found. This LED usually shows
> the state of streaming mode: this is the "Auto" mode. The LED can
> be programmed to constantly switched off state (e.g. for power saving
> reasons, preview mode) or on state (e.g. the application shows motion
> detection or "on-air").

Hi,

There may be many LEDs on the webcams. One LED may be used for
the streaming state, Some other ones may be used to give more light in
dark rooms. One webcam, the microscope 093a:050f, has a top and a bottom
lights/illuminators; an other one, the MSI StarCam 370i 0c45:60c0, has
an infra-red light.

That's why I proposed to have bit fields in the control value to switch
on/off each LED.

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
