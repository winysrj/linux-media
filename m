Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:58950 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbZFIBq6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Jun 2009 21:46:58 -0400
Subject: Re: [PATCHv6 3 of 7] Add documentation description for FM
 Transmitter Extended Control Class
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Eduardo Valentin <eduardo.valentin@nokia.com>,
	ext Mauro Carvalho Chehab <mchehab@infradead.org>,
	ext Douglas Schilling Landgraf <dougsland@gmail.com>,
	Linux-Media <linux-media@vger.kernel.org>,
	"Nurkkala Eero.An" <ext-eero.nurkkala@nokia.com>
In-Reply-To: <17445.62.70.2.252.1244461630.squirrel@webmail.xs4all.nl>
References: <17445.62.70.2.252.1244461630.squirrel@webmail.xs4all.nl>
Content-Type: text/plain
Date: Mon, 08 Jun 2009 21:47:33 -0400
Message-Id: <1244512053.3147.109.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-06-08 at 13:47 +0200, Hans Verkuil wrote:
> OK, I had some time, so here are a few comments:
> 
> > From: Eduardo Valentin <eduardo.valentin@nokia.com>

> > +	  <row><entry spanname="descr">Configures the pre-emphasis value for
> > broadcasting.
> > +A pre-emphasis filter is applied to the broadcast to accentuate the high
> > audio frequencies.
> > +Depending on the region, a time constant of either 50 or 75 useconds is
> > used. Possible values
> > +are:</entry>
> > +	</row><row>
> > +	<entrytbl spanname="descr" cols="2">
> > +		  <tbody valign="top">
> > +		    <row>
> > +
> > <entry><constant>V4L2_FMTX_PREEMPHASIS_DISABLED</constant>&nbsp;</entry>
> > +		      <entry>No pre-emphasis is applied.</entry>
> > +		    </row>
> > +		    <row>
> > +
> > <entry><constant>V4L2_FMTX_PREEMPHASIS_50_uS</constant>&nbsp;</entry>
> > +		      <entry>A pre-emphasis of 50 uS is used.</entry>
> > +		    </row>
> > +		    <row>
> > +
> > <entry><constant>V4L2_FMTX_PREEMPHASIS_75_uS</constant>&nbsp;</entry>
> > +		      <entry>A pre-emphasis of 75 uS is used.</entry>
> > +		    </row>
> > +		  </tbody>
> > +		</entrytbl>
> > +
> > +	  </row>
> 
> Do you know when to use which pre-emphasis?

I depends on what de-emphasis filter the receivers are using.  This is
usually a national or regional regulatory decision imposed upon the
broadcasters and hence receiver manufacturers.

The choice made by regulators probably depends on allowable field
strength (chosen by regulators) for the broadcast area and the expected
propagation conditions and man-made noise sources (which dominate in
VHF).

Preemphasis boosts the normally smaller magnitude, high frequency part
of the FM signal spectrum.  The receiver can then attenuate the received
noise and knock down the higher frequency part of the FM signal back
down to normal levels with a deemphasis filter.  The end result is an
imporved SNR for the high frequency part of the FM signal spectrum.

The CX25843 datasheet actually has an OK picture.

>  There is a similar MPEG
> control but I've never been able to find out when to use pre-emphasis and
> which mode should be used. I'd appreciate it if you can point me to some
> documentation on this issue. And perhaps that info should also be added to
> this doc.

If you have audio that you know has a lot of high frequency content
(televised music concert), you may wish to use pre-emphahsis filtering
before compression, and not use it for something with mostly low freqs
(a talk show).  You of course have to have the pre-emphasis filters
available and the ability to enable/disable them.

The preemphasis parameters in MPEG are to describe the preemphasis added
to the baseband audio, or the deepmhasis that must occur after the audio
is decompressed back to baseband.  The idea is that digitzation and
compression processing are going to introduce noise that will be
significant compared to the high frequency components of the audio.  A
preemphahsis filter amplifies these before sampling.  That way, after
reconstruction on the other end, the high frequency audio can be
deemphasized with a complementary filter.

MPEG can carry metadata specifying a 50/15 us or a CCITT J.17 filter
characteristic.

For 44.1 ksps, 50us and 15 us correspond to filter corner freqs of

1/(50 us * 2 * pi) = 3.183 kHz
1/(15 us * 2 * pi) = 10.61 kHz

with a 10 dB change in gain between the two corners (I think).


It looks like the CCITT J.17 curve corresponds to the pre-emphasis
filter used by NICAM.  There's a picture of the J.17 preemphasis curve
here in section 4.1:

http://tallyho.bc.nu/~steve/nicam.html

The CX25843 data sheet also has a picture of a NICAM de-emphasis filter
characteristic.

(Someone should really pull out the standards and verify all that.)



> > +	  <row>
> > +	    <entry
> > spanname="id"><constant>V4L2_CID_TUNE_ANTENNA_CAPACITOR</constant>&nbsp;</entry>
> > +	    <entry>integer</entry>
> > +	  </row>
> > +	  <row><entry spanname="descr">This selects the value of antenna tuning
> > capacitor
> > +manually or automatically if set to zero. Unit, range and step are
> > driver-specific.</entry>
> 
> Same question: is there a reason why the unit is driver-specific?


Because for a peaking control, an absolute unit doesn't matter.  It
would probably be too much work to figure out what they  Though for a
capacitor, one would expect a unit to be some fraction of a Farad.

If I'm guessing right, this value is used to tune an impedance matching
circuit for maximum power transfer to the antenna.  While tweaking this,
I assume one is inspecting an output somewhere else for a peak or
minimum level.  This really seems like something you usually want to
happen automatically with a control loop anyway (which is handled by the
0 case).

Regards,
Andy

> > +	  </row>
> > +	  <row><entry></entry></row>
> > +	</tbody>
> > +      </tgroup>
> > +      </table>
> > +    </section>
> >  </section>
> >
> >    <!--
> >
> 
> Regards,
> 
>          Hans


