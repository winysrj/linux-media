Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.163]:20371 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751087AbdKTBFi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 19 Nov 2017 20:05:38 -0500
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <23058.10847.150727.997348@morden.metzler>
Date: Mon, 20 Nov 2017 02:05:35 +0100
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
Subject: Re: DVB-S2 and S2X API extensions
In-Reply-To: <20171111082231.57cd5537@vela.lan>
References: <23044.29714.500132.822313@morden.metzler>
        <20171111082231.57cd5537@vela.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Mauro Carvalho Chehab writes:
 > Em Thu, 9 Nov 2017 16:28:18 +0100
 > Ralph Metzler <rjkm@metzlerbros.de> escreveu:
 > 
 > > Hi,
 > > 
 > > I have a few RFCs regarding new needed enums and
 > > properties for DVB-S2 and DVB-S2X:
 > > 
 > > - DVB-S2/X physical layer scrambling
 > > 
 > > I currently use the inofficial DTV_PLS for setting the scrambling
 > > sequence index (cf. ETSI EN 300 468 table 41) of
 > > the physical layer scrambling in DVB-S2 and DVB-S2X.
 > > Some drivers already misuse bits 8-27 of the DTV_STREAM_ID
 > > for setting this. They also differentiate between gold, root
 > > and combo codes.
 > > The gold code is the actual scrambling sequence index.
 > > The root code is just an intermediate calculation
 > > accepted by some chips, but derived from the gold code.
 > > It can be easily mapped one-to-one to the gold code.
 > > (see https://github.com/DigitalDevices/dddvb/blob/master/apps/pls.c,
 > > A more optimized version of this could be added to dvb-math.c)
 > > The combo code does not really exist but is a by-product
 > > of the buggy usage of a gold to root code conversion in ST chips.
 > > 
 > > So, I would propose to officially introduce a property
 > > for the scrambling sequence index (=gold code).
 > > Should it be called DTV_PLS (which I already used in the dddvb package)
 > > or rather DTV_SSI?
 > > I realized PLS can be confused with physical layer signalling which
 > > uses the acronym PLS in the DVB-S2 specs.
 > 
 > Yes, it makes sense to have a DTV property for the PLS gold code.
 > 
 > I would prefer to use a clearer name, like DTV_PLS_GOLD_CODE,
 > to make easier to identify what it means.
 > 
 > At documentation, we should point to EN 302 307 section 5.5.4 and
 > to EN 300 468 table 41, with a good enough description to make
 > clear that it is the gold code, and not the root code (or
 > a chipset-specific "combo" code).

If we use a long descriptive name, DTV_SCRAMBLING_SEQUENCE_INDEX might
be better because it is the actual name used for it in the documentation
and SI fields.


And, to make it absolutely clear, the combo code is not just a
chipset-specific code, it is utter BS!
Here is why (sorry for the lengthy explanation):

The STV090X/0910 chips have 3 8-bit registers for setting the
root code called PLROOT0, PLROOT1 and PLROOT2.
The code has 18 bits. So PLROOT0, PLROOT1 and the lower 2 bits
(bits 0 and 1) of PLROOT2 are the root code.
Bits 2 and 3 of PLROOT2 determine a mode with the following
3 possible values:
0 = the 18 bits are the root code
1 = the 18 bits are the gold code
2 = if you write the gold code to the 18 bits, they will
    be converted to the root code and you can then
    read them back, mode will be changed to 0 after
    conversion

This mode 2 is what somebody called "combo code".
But why is it seen as a different code? It should
behave just identical to writing a gold code!
Because some Linux drivers, probably also some
Windows drivers, first write PLROOT2, then PLROOT1 and
PLROOT0, also in the case of mode 2.
Writing the 2 in the mode bits actually triggers the
gold->root conversion and this conversion takes some time!

So, the conversion is triggered by the write to PLROOT2
even though PLROOT1 and PLROOT0 have not yet been written.
Depending on many factors like I2C write speed, the
computer speed, other tasks running, etc. and especially also
the previous values of PLROOT1 and PLROOT2, you will get
varying results after the conversion.
The length of the conversion also depends on the size of
the gold code.
For small gold codes the conversion is so fast that
it is finished before PLROOT1 and PLROOT2 are written.
The lower 16 bits of the conversion results will actually be overwritten
again! For larger gold codes only the lower 8 bits, etc.

Think about all the race conditions and wrong initial values in this
process and everybody please forget about "combo code"!



 > > DVB-S2X also defines 7 preferred scrambling code sequences
 > > (EN 302 307-2 5.5.4) which should be checked during tuning.
 > > If the demod does not do this, should the DVB kernel layer or
 > > application do this?
 > 
 > IMHO, it should be up to the kernel to check if the received
 > gold code is one of those 7 codes from EM 302 307 part 2 spec,
 > if the delivery system is DVB_S2X (btw, we likely need to add it
 > to the list of delivery systems). Not sure what would be the
 > best way to implement it. Perhaps via some ancillary routine
 > that the demods would be using.
 > 
 > > - slices
 > > 
 > > DVB-S2 and DVB-C2, additionally to ISI/PLP, also can have
 > > slicing. For DVB-C2 I currently use bits 8-15 of DTV_STREAM_ID as slice id.
 > 
 > Better to use a separate property for that. On the documentation
 > patches I wrote, I made clear that, for DVB-S2, only 8 bits of
 > DTV_STREAM_ID are valid.
 > 
 > We need to add DVB-C2 delivery system and update documentation
 > accordingly. I made an effort to document, per DTV property,
 > what delivery systems accept them, and what are the valid
 > values, per standard.
 > 
 > > For DVB-S2/X the misuse of bits 8-27 by some drivers for selecting
 > > the scrambling sequence index code could cause problems.
 > > Should there be a new property for slice selection?
 > 
 > Yes.
 > 
 > > It is recommended that slice id and ISI/PLP id are identical but they
 > > can be different.
 > 
 > The new property should reserve a value (0 or (unsigned)-1) to mean "AUTO",
 > in the sense that slice ID will be identical to ISI/PLP, being the default.
 > 
 > > - new DVB-S2X features
 > > 
 > > DVB-S2X needs some more roll-offs, FECs and modulations. I guess adding those
 > > should be no problem?
 > 
 > Yes, just adding those are OK. We should just document what values are 
 > valid for DVB-S2X at the spec.
 > 
 > Ok, this is actually already at the specs, but it helps application
 > developers to ensure that their apps will only send valid values to the
 > Kernel, if we keep such information at the uAPI documentation.
 > 
 > > Do we need FE_CAN_SLICES, FE_CAN_3G_MODULATION, etc?
 > 
 > That is a good question. On my opinion, yes, we should add new
 > capabilities there, but we're out of space at the u32 caps that we
 > use for capabilities (there are other missing caps there for other
 > new standards).
 > 
 > We could start using a DTV property for capabilities, or define
 > a variant of FE_GET_INFO that would use an u64 value for
 > the caps field.
 > 
 > > Or would a new delivery system type for S2X make sense?
 > 
 > IMHO, it makes sense to have a new delivery system type for S2X.
 > A FE_CAN_3G_MODULATION (and, in the future, CAN_4G, CAN_5G, ...)
 > could work too, but not sure how this would scale in the future,
 > as support for older variants could be removed from some devices,
 > e. g. a given demod could, for instance, support 3G, 4G and 5G
 > but won't be able to work with 1G or 2G.
 > 
 > My guess is that multiple delivery systems would scale better.


In the case of DVB-S2X I am not sure anymore if this is really a new
delivery system. S2X only consists of extensions to S2. 
E.g., some modcods which were optional for DVB-S2 were made
mandatory for DVB-S2X (so they are rather just a capability like
multi-stream), other modcods are new in S2X.
Features like slicing are even just an optional annex to S2 and not
part of S2X.


 > > -DVB-S2 base band frame support
 > > 
 > > There are some older patches which allowed to switch the demod
 > > to a raw BB frame mode (if it and the bridge support this) and
 > > have those parsed in the DVB layer.
 > > 
 > > See
 > > https://patchwork.linuxtv.org/patch/10402/
 > > or
 > > https://linuxtv.org/pipermail/linux-dvb/2007-December/022217.html
 > > 
 > > Chris Lee seems to have a tree based on those:
 > > https://bitbucket.org/updatelee/v4l-updatelee
 > > 
 > > 
 > > Another method to support this is to wrap the BB frames
 > > into sections and deliver them as a normal transport stream.
 > > Some demods and/or PCIe bridges support this in hardware.
 > > This has the advantage that it would even work with SAT>IP.
 > > 
 > > How should the latter method be supported in the DVB API?
 > > With a special stream id or separate porperty?
 > > Switching to this mode could even be done automatically
 > > in case of non-TS streams.
 > 
 > That's a very good question. 
 > 
 > I guess we'll need to add support at the demux API to inform/select
 > the output format anyway, in order to support, for example, ATSC
 > version 3, with is based on MMT, instead of MPEG-TS.
 > 
 > One thing that it is on my todo list for a while (with very low priority)
 > would be to allow userspace to select between 188 or 204 packet sizes,
 > as recording full mpeg-TS with 204 size makes easy to reproduce ISDB-T
 > data on my Dectec RF modulators :-) The dtplay default command line
 > application doesn't allow specifying layer information (there is a fork
 > of it that does, though). Yet, as this would require to change the
 > ISDB-T demod as well to be useful (and this is just meant to
 > avoid me the need to run the MS application), this is something that I've
 > been systematically postponing, in favor of things that would be more
 > useful for the general audience.
 > 
 > Anyway, IMHO, it is time to work at the demux API to add a way to list
 > what kind of output types it supports and to let userspace select the
 > one that it is more adequate for its usecase, if multiple ones are
 > supported.


For the BB frame wrapping in sections I wrote about above I only need
a selection switch and no changes to the demux.
The wrapping is all done in hardware.

But you are right, more flexibility in the demux API could be useful
for the 204 byte packets you mentioned, other formats which contain
timestamp headers, MMT, etc. 


Regards,
Ralph
