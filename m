Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:34501 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbaCLRP5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Mar 2014 13:15:57 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N2C000S12MKTK40@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 12 Mar 2014 13:15:56 -0400 (EDT)
Date: Wed, 12 Mar 2014 14:15:50 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [REVIEW PATCH 11/13] DocBook: document RF tuner bandwidth controls
Message-id: <20140312141550.32aa5ccf@samsung.com>
In-reply-to: <53206DD2.4000504@iki.fi>
References: <1393460528-11684-1-git-send-email-crope@iki.fi>
 <1393460528-11684-12-git-send-email-crope@iki.fi>
 <20140305154922.508c48d7@samsung.com> <531D8D78.800@iki.fi>
 <20140312080233.3823dd80@samsung.com> <5320527B.9040707@iki.fi>
 <20140312094739.089a8ce5@samsung.com> <532059B0.9010201@iki.fi>
 <53205BF6.9040304@iki.fi> <20140312102118.79956fd3@samsung.com>
 <53206DD2.4000504@iki.fi>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 12 Mar 2014 16:23:14 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> On 12.03.2014 15:21, Mauro Carvalho Chehab wrote:
> > Em Wed, 12 Mar 2014 15:07:02 +0200
> > Antti Palosaari <crope@iki.fi> escreveu:
> >
> >> On 12.03.2014 14:57, Antti Palosaari wrote:
> >>> On 12.03.2014 14:47, Mauro Carvalho Chehab wrote:
> >>>> Em Wed, 12 Mar 2014 14:26:35 +0200
> >>>> Antti Palosaari <crope@iki.fi> escreveu:
> >>>>
> >>>>> On 12.03.2014 13:02, Mauro Carvalho Chehab wrote:
> >>>>>> Em Mon, 10 Mar 2014 12:01:28 +0200
> >>>>>> Antti Palosaari <crope@iki.fi> escreveu:
> >>>>>>
> >>>>>>> On 05.03.2014 20:49, Mauro Carvalho Chehab wrote:
> >>>>>>>> Em Thu, 27 Feb 2014 02:22:06 +0200
> >>>>>>>> Antti Palosaari <crope@iki.fi> escreveu:
> >>>>>>>>
> >>>>>>>>> Add documentation for RF tuner bandwidth controls. These controls
> >>>>>>>>> are
> >>>>>>>>> used to set filters on tuner signal path.
> >>>>>>>>>
> >>>>>>>>> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> >>>>>>>>> Signed-off-by: Antti Palosaari <crope@iki.fi>
> >>>>>>>>> ---
> >>>>>>>>>      Documentation/DocBook/media/v4l/controls.xml | 19
> >>>>>>>>> +++++++++++++++++++
> >>>>>>>>>      1 file changed, 19 insertions(+)
> >>>>>>>>>
> >>>>>>>>> diff --git a/Documentation/DocBook/media/v4l/controls.xml
> >>>>>>>>> b/Documentation/DocBook/media/v4l/controls.xml
> >>>>>>>>> index 6c9dbf6..5550fea 100644
> >>>>>>>>> --- a/Documentation/DocBook/media/v4l/controls.xml
> >>>>>>>>> +++ b/Documentation/DocBook/media/v4l/controls.xml
> >>>>>>>>> @@ -5007,6 +5007,25 @@ descriptor. Calling &VIDIOC-QUERYCTRL; for
> >>>>>>>>> this control will return a
> >>>>>>>>>      description of this control class.</entry>
> >>>>>>>>>                  </row>
> >>>>>>>>>                  <row>
> >>>>>>>>> +              <entry
> >>>>>>>>> spanname="id"><constant>V4L2_CID_RF_TUNER_BANDWIDTH_AUTO</constant>&nbsp;</entry>
> >>>>>>>>>
> >>>>>>>>> +              <entry>boolean</entry>
> >>>>>>>>> +            </row>
> >>>>>>>>> +            <row>
> >>>>>>>>> +              <entry spanname="descr">Enables/disables tuner
> >>>>>>>>> radio channel
> >>>>>>>>> +bandwidth configuration. In automatic mode bandwidth
> >>>>>>>>> configuration is performed
> >>>>>>>>> +by the driver.</entry>
> >>>>>>>>> +            </row>
> >>>>>>>>> +            <row>
> >>>>>>>>> +              <entry
> >>>>>>>>> spanname="id"><constant>V4L2_CID_RF_TUNER_BANDWIDTH</constant>&nbsp;</entry>
> >>>>>>>>>
> >>>>>>>>> +              <entry>integer</entry>
> >>>>>>>>> +            </row>
> >>>>>>>>> +            <row>
> >>>>>>>>> +              <entry spanname="descr">Filter(s) on tuner signal
> >>>>>>>>> path are used to
> >>>>>>>>> +filter signal according to receiving party needs. Driver
> >>>>>>>>> configures filters to
> >>>>>>>>> +fulfill desired bandwidth requirement. Used when
> >>>>>>>>> V4L2_CID_RF_TUNER_BANDWIDTH_AUTO is not
> >>>>>>>>> +set. The range and step are driver-specific.</entry>
> >>>>>>>>
> >>>>>>>> Huh? If this is enable/disable, why "the range and step are
> >>>>>>>> driver-specific"?
> >>>>>>>
> >>>>>>> Because there is two controls grouped. That is situation of having
> >>>>>>> AUTO/MANUAL.
> >>>>>>> V4L2_CID_RF_TUNER_BANDWIDTH_AUTO
> >>>>>>> V4L2_CID_RF_TUNER_BANDWIDTH
> >>>>>>>
> >>>>>>> V4L2_CID_RF_TUNER_BANDWIDTH is valid only when
> >>>>>>> V4L2_CID_RF_TUNER_BANDWIDTH_AUTO == false.
> >>>>>>>
> >>>>>>
> >>>>>> Sorry, but I'm not understanding what you're arguing.
> >>>>>>
> >>>>>> Yeah, it is clear at the patch that there are two controls, and that
> >>>>>> V4L2_CID_RF_TUNER_BANDWIDTH is valid only when AUTO is disabled, but
> >>>>>> this doesn't answer my question:
> >>>>>>
> >>>>>> Why V4L2_CID_RF_TUNER_BANDWIDTH's range and step are driver-specific?
> >>>>>>
> >>>>>
> >>>>> Hmmm. That control is used to configure RF filters. Filters set
> >>>>> bandwidth of radio channel. There is usually quite limited set of
> >>>>> available analog filters inside RF tuner. If you look for example
> >>>>> FC0012/FC0013 possible filters are 6/7/8 MHz. E4000 has something 4-11
> >>>>> MHz. If you look those very old 1st gen silicon tuners like QT1010 /
> >>>>> MT2060, there is no integrated filters at all - but there is external
> >>>>> saw filter which is usually 8MHz at 36.125 MHz IF.
> >>>>>
> >>>>> Did you remember there is same parameter already in DVB API (struct
> >>>>> dtv_frontend_properties bandwidth_hz)? That is control is currently used
> >>>>> to set r820t, fc0012, fc10013 .bandwidth_hz value, e4000 implements it
> >>>>> correctly as own control.
> >>>>>
> >>>>> I am quite astonished we have that big gap with our views.
> >>>>
> >>>> Well, on DVB, the bandwidth is specified in Hz, at DVBv5 (or via
> >>>> an enum on DVBv3).
> >>>>
> >>>> Here, there's no description about the unit to be used (Hz? kHz?).
> >>>> It just says that this is an integer, with a driver-specific
> >>>> range and step.
> >>>>
> >>>> So, one driver might choose to use Hz, other kHz, and other to
> >>>> expose some internal counter. That's bad.
> >>>>
> >>>> We should either use a V4L2_CTRL_TYPE_MENU type of control, where it
> >>>> would be possible to do something similar to DVBv3 way to specify
> >>>> the bandwidth filter, or to define that the bandwidth will be
> >>>> in Hz, kHz or MHz.
> >>>
> >>> Yeah, indeed. That was my mistake. The aim was Hz yes.
> >>>
> >>>>
> >>>> Probably, a menu type is better, as it allows userspace to get
> >>>> all supported bandwidths.
> >>>
> >>> I though it too, but there is already a lot choices for some tuners,
> >>> E4000 has over 30. What is maximum reasonable filter count for
> >>> V4L2_CTRL_TYPE_MENU?
> >
> > I don't see any troubles on having 30 items there. Maybe Hans is aware
> > of some troubles on having such number of items.
> >
> > The advantage of a menu type is that it helps userspace to select
> > an existing range.
> >
> >> One fear there is also what happens when there will be some day new RF
> >> tuner having DSP which does digital filtering ~1 Hz step?
> >
> > It is possible.
> >
> >> Mabbe the current control is enough, but probably it is place to add
> >> comment unit is Hz (even I think people should expect it is Hz when RF
> >> frequencies are spoken).
> >
> > Please remind that V4L2 API has 3 scales already for frequencies,
> > HZ being the less obvious one, as it is the one added only for
> > 3.14 and upper.
> >
> > I see two alternatives here:
> >
> > 1) say that this is always Hz. The problem is if some future hardware
> > would support a bandwidth bigger than 2 GHz. That's unlikely, as
> > using such filter would require a wide band antenna, but
> > I won't doubt that this might happen some day;
> 
> Antenna dimensions are relative. 2GHz is not so much when we speak 
> frequencies over 100 GHz and so.

Yes, I know.

> But it is very far away from the  environment we are now playing with...

I went once to a speech from one engineer working at one mobile manufacturer
that was experimenting with very wide band antenas. The idea were to have
just one antenna and one radio able to get the all the band used by AM, FM
and GSM/CDMA at the same time. This was several years ago. Not sure about
any progress made on that direction, but we should keep our minds open,
when dealing with an API that could potentially support things like that.

> > 2) say that this should follow the corresponding tuner CAPS for
> > frequencies (V4L2_TUNER_CAP_LOW, V4L2_TUNER_CAP_NORM, V4L2_TUNER_CAP_1HZ).
> >
> > The advantage of (2) is that, if we latter need to support wide band
> > filters, one would just need to use V4L2_TUNER_CAP_NORM (or a newer
> > V4L2_TUNER_CAP_1KHZ).
> 
> That is fine for me too, but I suspect Hans don't like it, as those 
> steps are mapped "V4L tuner API", right?

Hans?

> Anyway, is that something we can just put in and fine tune later if 
> needed? 

Well, we should define something there. I would then say that this
is in 1Hz scale, and should be used only for SDR drivers that use
V4L2_TUNER_CAP_1HZ.

That would give us some flexibility to change it later if needed.

> I cannot see big issues and it is still experimental and all 
> drivers are staging....

Having the drivers at staging helps, but I doubt that we'll remind
to review this when moving the driver upstream. So, better to let
the API document to reflect what's implemented, in order to make
our lives easier when migrating this out of staging.

Regards,
Mauro
