Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:48351 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751177Ab1KYD25 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 22:28:57 -0500
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: Linux Media Mailing List <linux-media@vger.kernel.org>
To: Manu Abraham <abraham.manu@gmail.com>
Subject: Re: PATCH v3: Query DVB frontend delivery capabilities (was: Re: PATCH: Query DVB frontend capabilities)
Date: Fri, 25 Nov 2011 04:10:01 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <CAHFNz9JW-CyOsFutMNkfVZ-KuJX2FE1DZ_AQ5TZne4CCypLYng@mail.gmail.com>
In-Reply-To: <CAHFNz9JW-CyOsFutMNkfVZ-KuJX2FE1DZ_AQ5TZne4CCypLYng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201111250410.02883@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 14 November 2011 20:39:48 Manu Abraham wrote:
> On 11/12/11, Andreas Oberritter <obi@linuxtv.org> wrote:
> > On 11.11.2011 23:38, Mauro Carvalho Chehab wrote:
> >> Em 11-11-2011 20:07, Manu Abraham escreveu:
> >>> On Fri, Nov 11, 2011 at 3:42 PM, Mauro Carvalho Chehab
> >>> <mchehab@redhat.com> wrote:
> >>>> Em 11-11-2011 04:26, Manu Abraham escreveu:
> >>>>> On Fri, Nov 11, 2011 at 2:50 AM, Mauro Carvalho Chehab
> >>>>> <mchehab@redhat.com> wrote:
> >>>>>> Em 10-11-2011 13:30, Manu Abraham escreveu:
> >>>>> The purpose of the patch is to
> >>>>> query DVB delivery system capabilities alone, rather than DVB frontend
> >>>>> info/capability.
> >>>>>
> >>>>> Attached is a revised version 2 of the patch, which addresses the
> >>>>> issues that were raised.
> >>>>
> >>>> It looks good for me. I would just rename it to DTV_SUPPORTED_DELIVERY.
> >>>> Please, when submitting upstream, don't forget to increment DVB version
> >>>> and
> >>>> add touch at DocBook, in order to not increase the gap between API specs
> >>>> and the
> >>>> implementation.
> >>>
> >>> Ok, thanks for the feedback, will do that.
> >>>
> >>> The naming issue is trivial. I would like to have a shorter name
> >>> rather that SUPPORTED. CAPS would have been ideal, since it refers to
> >>> device capability.
> >>
> >> CAPS is not a good name, as there are those two CAPABILITIES calls there
> >> (well, currently not implemented). So, it can lead in to some confusion.
> >>
> >> DTV_ENUM_DELIVERY could be an alternative for a short name to be used
> >> there.
> >
> > I like "enum", because it suggests that it's a read-only property.
> >
> > DVB calls them "delivery systems", so maybe DTV_ENUM_DELSYS may be an
> > alternative.
> 
> This is a bit more sensible and meaningful than the others. I like
> this one better than the others.
> 
> Attached is a version 3 patch which addresses all the issues that were raised.

Fine for me. (I do not care about the name of the game.)

Acked-by: Oliver Endriss <o.endriss@gmx.de>

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
