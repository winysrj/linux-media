Return-path: <linux-media-owner@vger.kernel.org>
Received: from oyp.chewa.net ([91.121.6.101]:35872 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754556Ab2EVQ0l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 May 2012 12:26:41 -0400
From: "=?iso-8859-1?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: RFC: V4L2 API and radio devices with multiple tuners
Date: Tue, 22 May 2012 19:26:37 +0300
Cc: Hans de Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Ondrej Zary <linux@rainbow-software.org>
References: <4FB7E489.10803@redhat.com> <4FB7E827.7070701@iki.fi>
In-Reply-To: <4FB7E827.7070701@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201205221926.38970.remi@remlab.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le samedi 19 mai 2012 21:36:23 Antti Palosaari, vous avez écrit :
> On 19.05.2012 21:20, Hans de Goede wrote:
> > Currently the V4L2 API does not allow for radio devices with more then 1
> > tuner,
> > which is a bit of a historical oversight, since many radio devices have 2
> > tuners/demodulators 1 for FM and one for AM. Trying to model this as 1
> > tuner
> > really does not work well, as they have 2 completely separate frequency
> > bands
> > they handle, as well as different properties (the FM part usually is
> > stereo capable, the AM part is not).
> > 
> > It is important to realize here that usually the AM/FM tuners are part
> > of 1 chip, and often have only 1 frequency register which is used in
> > both AM/FM modes. IOW it more or less is one tuner, but with 2 modes,
> > and from a V4L2 API pov these modes are best modeled as 2 tuners.
> > This is at least true for the radio-cadet card and the tea575x,
> > which are the only 2 AM capable radio devices we currently know about.
> 
> For DVB API we changed just opposite direction - from multi-frontend to
> single-frontend. I think one device per one standard is good choice.

If I understand Hans correctly, he suggests to use two tuners on a *single* 
radio device node, much like a single video device nodes can have multiple 
video inputs. So I think you agree with Hans, and so do I.

-- 
Rémi Denis-Courmont
http://www.remlab.net/
http://fi.linkedin.com/in/remidenis
