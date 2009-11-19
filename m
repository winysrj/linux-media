Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:47633 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbZKSLsH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2009 06:48:07 -0500
Date: Thu, 19 Nov 2009 12:48:21 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	linux-media@vger.kernel.org
Subject: Re: [RFC, PATCH] gspca: implement vidioc_enum_frameintervals
Message-ID: <20091119124821.25524a23@tele>
In-Reply-To: <4B0527D9.8000800@redhat.com>
References: <20091117114147.09889427.ospite@studenti.unina.it>
	<4B04FCF6.2060505@redhat.com>
	<20091119113719.566ba78e.ospite@studenti.unina.it>
	<4B0527D9.8000800@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 19 Nov 2009 12:11:21 +0100
Hans de Goede <hdegoede@redhat.com> wrote:

> Hmm, I see now upon expecting the code that the driver does actually
> support setting the framerate, but what I see does not seem
> to match your patch, the driver seems to support 50, 40, 30 and 15
> fps, where as your patch has:
> 
> static int qvga_rates[] = {125, 100, 75, 60, 50, 40, 30};
> static int vga_rates[] = {60, 50, 40, 30, 15};

Hi,

The function set_frame_rate() is changed in my test repository.

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
