Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:43675 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436Ab3ETWXX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 May 2013 18:23:23 -0400
Received: by mail-lb0-f169.google.com with SMTP id 10so63927lbf.0
        for <linux-media@vger.kernel.org>; Mon, 20 May 2013 15:23:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201305101346.28876.hverkuil@xs4all.nl>
References: <1367943863-28803-1-git-send-email-koradlow@gmail.com>
	<59e7b78e35403e1157483794d5d7d796b46ed0c4.1367943797.git.koradlow@gmail.com>
	<201305101346.28876.hverkuil@xs4all.nl>
Date: Mon, 20 May 2013 23:23:21 +0100
Message-ID: <CAFomkUDB-1C0HBqeTec0vzKqVBSyzeFySyXJX4XyfR_XwgG6yA@mail.gmail.com>
Subject: Re: [RFC PATCH 3/4] libv4l2rds: added support to decode RDS-TMC
 tuning information
From: Konke Radlow <koradlow@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,
Thank you for your comments, they're very appreciated as always :)

I will integrate the proposals and submit an updated version towards
the end of this week.

To my best knowledge I would say that the functionality of RDS/TMC as
defined by the standards is completely implemented now.

And I agree that human readable output for the TMC messages would be
nice to have, but I'm quite busy with my thesis atm and will not make
any promises ;)

Cheers,
Konke

On Fri, May 10, 2013 at 12:46 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Tue May 7 2013 18:24:22 Konke Radlow wrote:
>> Signed-off-by: Konke Radlow <koradlow@gmail.com>
>> ---
>>  lib/include/libv4l2rds.h    |   39 +++++++++++
>>  lib/libv4l2rds/libv4l2rds.c |  159 +++++++++++++++++++++++++++++++++++++++++--
>>  2 files changed, 194 insertions(+), 4 deletions(-)
>>
>> diff --git a/lib/include/libv4l2rds.h b/lib/include/libv4l2rds.h
>> index 62b28bc..45dc2d1 100644
>> --- a/lib/include/libv4l2rds.h
>> +++ b/lib/include/libv4l2rds.h
>> @@ -50,6 +50,10 @@ extern "C" {
>>                       * Additional data is limited to 112 bit, and the smallest
>>                       * optional tuple has a size of 4 bit (4 bit identifier +
>>                       * 0 bits of data) */
>> +#define MAX_TMC_ALT_STATIONS 32 /* defined by ISO 14819-1:2003, 7.5.3.3  */
>> +#define MAX_TMC_AF_CNT 4     /* limit for the numbers of AFs stored per alternative TMC
>> +                     * station. This value is not defined by the standard, but based on observation
>> +                     * of real-world RDS-TMC streams */
>
> Could you clarify this a bit more? E.g. what is the maximum number of AFs you
> have seen in practice?
>
>>  #define MAX_EON_CNT 20       /* Maximal number of entries in the EON table (for storing
>>                       * information about other radio stations, broadcasted
>>                       * by the current station) */
>> @@ -75,6 +79,7 @@ extern "C" {
>>  #define V4L2_RDS_TMC_SYS     0x10000 /* RDS-TMC system information */
>>  #define V4L2_RDS_EON         0x20000 /* Enhanced Other Network Info */
>>  #define V4L2_RDS_LSF         0x40000 /* Linkage information */
>> +#define V4L2_RDS_TMC_TUNING  0x80000 /* RDS-TMC tuning information */
>>
>>  /* Define Constants for the state of the RDS decoding process
>>   * used to address the relevant bit in the decode_information bitmask */
>> @@ -175,6 +180,37 @@ struct v4l2_rds_eon_set {
>>                                                * radio channels */
>>  };
>>
>> +/* struct to encapsulate alternative frequencies (AFs) for RDS-TMC stations.
>> + * AFs listed in af[] can be used unconditionally.
>> + * AFs listed in mapped_af[n] should only be used if the current
>> + * tuner frequency matches the value in mapped_af_tuning[n] */
>> +struct v4l2_tmc_alt_freq {
>> +     uint8_t af_size;                /* number of known AFs */
>> +     uint8_t af_index;
>> +     uint8_t mapped_af_size;         /* number of mapped AFs */
>> +     uint8_t mapped_af_index;
>> +     uint32_t af[MAX_TMC_AF_CNT];            /* AFs defined in Hz */
>> +     uint32_t mapped_af[MAX_TMC_AF_CNT];             /* mapped AFs defined in Hz */
>> +     uint32_t mapped_af_tuning[MAX_TMC_AF_CNT];      /* mapped AFs defined in Hz */
>> +};
>> +
>> +/* struct to encapsulate information about stations carrying RDS-TMC services */
>> +struct v4l2_tmc_station {
>> +     uint16_t pi;
>> +     uint8_t ltn;    /* database-ID of ON */
>> +     uint8_t msg;    /* msg parameters of ON */
>> +     uint8_t sid;    /* service-ID of ON */
>> +     struct v4l2_tmc_alt_freq afi;
>> +};
>> +
>> +/* struct to encapsulate tuning information for TMC */
>> +struct v4l2_tmc_tuning {
>> +     uint8_t station_cnt;    /* number of announced alternative stations */
>> +     uint8_t index;
>> +     struct v4l2_tmc_station station[MAX_TMC_ALT_STATIONS];  /* information
>> +                                                     * about other stations carrying the same RDS-TMC service */
>> +};
>> +
>>  /* struct to encapsulate an additional data field in a TMC message */
>>  struct v4l2_tmc_additional {
>>       uint8_t label;
>> @@ -225,6 +261,9 @@ struct v4l2_rds_tmc {
>>       uint8_t t_d;            /* delay time (only if mode = enhanced */
>>       uint8_t spn[9];         /* service provider name */
>>       struct v4l2_rds_tmc_msg tmc_msg;
>> +
>> +     /* tuning information for alternative service providers */
>> +     struct v4l2_tmc_tuning tuning;
>>  };
>>
>>  /* struct to encapsulate state and RDS information for current decoding process */
>> diff --git a/lib/libv4l2rds/libv4l2rds.c b/lib/libv4l2rds/libv4l2rds.c
>> index 3a90a3b..3995c3d 100644
>> --- a/lib/libv4l2rds/libv4l2rds.c
>> +++ b/lib/libv4l2rds/libv4l2rds.c
>> @@ -93,7 +93,9 @@ enum rds_state {
>>  };
>>
>>  /* function declarations to prevent the need to move large code blocks */
>> +static int rds_add_tmc_station(struct rds_private_state *priv_state, uint16_t pi);
>>  static uint32_t rds_decode_af(uint8_t af, bool is_vhf);
>> +static bool rds_add_tmc_af(struct rds_private_state *priv_state);
>
> Same comment as previously: just have a separate patch that moves code around.
>
>>
>>  static inline uint8_t set_bit(uint8_t input, uint8_t bitmask, bool bitvalue)
>>  {
>> @@ -437,6 +439,59 @@ static uint32_t rds_decode_tmc_multi_group(struct rds_private_state *priv_state)
>>       return V4L2_RDS_TMC_MG;
>>  }
>>
>> +/* decode the RDS-TMC tuning information that is contained in type 8A groups
>> + * (variants 4 to 9) that announce the presence alternative transmitters
>> + * providing the same RDS-TMC service */
>> +static uint32_t rds_decode_tmc_tuning(struct rds_private_state *priv_state)
>> +{
>> +     struct v4l2_rds_group *group = &priv_state->rds_group;
>> +     struct v4l2_rds_tmc *tmc = &priv_state->handle.tmc;
>> +     uint8_t variant_code = group->data_b_lsb & 0x0f;
>> +     uint16_t pi_on = (group->data_d_msb << 8) | group->data_d_lsb;
>> +     uint8_t index;
>> +
>> +     /* variants 4 and 5 carry the service provider name */
>> +     if (variant_code >= 4 && variant_code <= 5) {
>> +             int offset = 4 * (variant_code - 4);
>> +             tmc->spn[0 + offset] = group->data_c_msb;
>> +             tmc->spn[1 + offset] = group->data_c_lsb;
>> +             tmc->spn[2 + offset] = group->data_d_msb;
>> +             tmc->spn[3 + offset] = group->data_d_lsb;
>> +
>> +     /* variant 6 provides specific frequencies for the same RDS-TMC service
>> +      * on a network with a different PI code */
>> +     /* variant 7 provides mapped frequency pair information which should only
>> +      * be used if the terminal is tuned to the tuning frequency */
>> +     } else if (variant_code == 6 || variant_code == 7) {
>> +             rds_add_tmc_af(priv_state);
>> +
>> +     /* variant 8 indicates up to 2 PI codes of adjacent networks carrying
>> +      * the same RDS-TMC service on all transmitters of the network */
>> +     } else if (variant_code == 8) {
>> +             uint16_t pi_on_2 = (group->data_c_msb << 8) | group->data_c_lsb;
>> +
>> +             /* try to add both transmitted PI codes to the table */
>> +             rds_add_tmc_station(priv_state, pi_on);
>> +             /* PI = 0 is used as a filler code */
>> +             if (pi_on_2 != 0) rds_add_tmc_station(priv_state, pi_on_2);
>
> Newline before rds_add_tmc_station().
>
>> +
>> +     /* variant 9 provides PI codes of other networks with different system
>> +      * parameters */
>> +     } else if (variant_code == 9) {
>> +             index = rds_add_tmc_station(priv_state, pi_on);
>> +
>> +             /* bits 0 - 5 contain the service-ID of the ON */
>> +             tmc->tuning.station[index].sid = group->data_c_lsb & 0x3F;
>> +             /* bits 6-10 contain the msg parameters of the ON */
>> +             tmc->tuning.station[index].msg = (group->data_c_msb & 0x03) << 2;
>> +             tmc->tuning.station[index].msg |= (group->data_c_lsb >> 6) & 0x03;
>> +             /* bits 11-15 contain the database-ID of the ON */
>> +             tmc->tuning.station[index].ltn = group->data_c_msb >> 2;
>> +     }
>> +
>> +     return V4L2_RDS_TMC_TUNING;
>> +}
>> +
>>  static bool rds_add_oda(struct rds_private_state *priv_state, struct v4l2_rds_oda oda)
>>  {
>>       struct v4l2_rds *handle = &priv_state->handle;
>> @@ -516,6 +571,103 @@ static bool rds_add_af(struct rds_private_state *priv_state)
>>       return updated_af;
>>  }
>>
>> +/* checks if an entry for the given PI already exists and returns the index
>> + * of that entry if so. Else it adds a new entry to the TMC-Tuning table and returns
>> + * the index of the new field */
>> +static int rds_add_tmc_station(struct rds_private_state *priv_state, uint16_t pi)
>> +{
>> +     struct v4l2_tmc_tuning *tuning = &priv_state->handle.tmc.tuning;
>> +     uint8_t index = tuning->index;
>> +     uint8_t size = tuning->station_cnt;
>> +
>> +     /* check if there's an entry for the given PI key */
>> +     for (int i = 0; i < tuning->station_cnt; i++) {
>> +             if (tuning->station[i].pi == pi) {
>> +                     return i;
>> +             }
>> +     }
>> +     /* if the the maximum table size is reached, overwrite old
>> +      * entries, starting at the oldest one = 0 */
>> +     tuning->station[index].pi = pi;
>> +     tuning->index = (index+1 < MAX_TMC_ALT_STATIONS)? (index+1) : 0;
>
> Space before '?'
>
>> +     tuning->station_cnt = (size+1 <= MAX_TMC_ALT_STATIONS)? (size+1) : MAX_TMC_ALT_STATIONS;
>
> Ditto. You do this elsewhere as well, please check :-)
>
>> +     return index;
>> +}
>> +
>> +/* tries to add new AFs to the relevant entry in the list of RDS-TMC providers */
>> +static bool rds_add_tmc_af(struct rds_private_state *priv_state)
>> +{
>> +     struct v4l2_rds_group *grp = &priv_state->rds_group;
>> +     struct v4l2_tmc_alt_freq *afi;
>> +     uint16_t pi_on = grp->data_d_msb << 8 | grp->data_d_lsb;
>> +     uint8_t variant = grp->data_b_lsb & 0x0f;
>> +     uint8_t station_index = rds_add_tmc_station(priv_state, pi_on);
>> +     uint8_t af_index;
>> +     uint8_t mapped_af_index;
>> +     uint32_t freq_a = rds_decode_af(grp->data_c_msb, true);
>> +     uint32_t freq_b = rds_decode_af(grp->data_c_lsb, true);
>> +
>> +     afi = &priv_state->handle.tmc.tuning.station[station_index].afi;
>> +     af_index = afi->af_index;
>> +     mapped_af_index = afi->mapped_af_index;
>> +
>> +     /* specific frequencies */
>> +     if (variant == 6) {
>> +             /* compare the new AFs to the stored ones, reset them to 0 if the AFs are
>> +              * already known */
>> +             for (int i = 0; i < afi->af_size; i++) {
>> +                     freq_a = (freq_a == afi->af[i])? 0 : freq_a;
>> +                     freq_b = (freq_b == afi->af[i])? 0 : freq_b;
>> +             }
>> +             /* return early if there is nothing to do */
>> +             if (freq_a == 0 && freq_b == 0)
>> +                     return false;
>> +
>> +             /* add the new AFs if they were previously unknown */
>> +             if (freq_a != 0) {
>> +                     afi->af[af_index] = freq_a;
>> +                     af_index = (af_index+1 < MAX_TMC_AF_CNT)? af_index+1 : 0;
>> +                     afi->af_size++;
>> +             }
>> +             if (freq_b != 0) {
>> +                     afi->af[af_index] = freq_b;
>> +                     af_index = (af_index+1 < MAX_TMC_AF_CNT)? af_index+1 : 0;
>> +                     afi->af_size++;
>> +             }
>> +             /* update the information in the handle */
>> +             afi->af_index = af_index;
>> +             if (afi->af_size >= MAX_TMC_AF_CNT)
>> +                     afi->af_size = MAX_TMC_AF_CNT;
>> +
>> +             return true;
>> +     }
>> +
>> +     /* mapped frequency pair */
>> +     else if (variant == 7) {
>> +             /* check the if there's already a frequency mapped to the new tuning
>> +              * frequency, update the mapped frequency in this case */
>> +             for (int i = 0; i < afi->mapped_af_size; i++) {
>> +                     if (freq_a == afi->mapped_af_tuning[i])
>> +                             afi->mapped_af[i] = freq_b;
>> +                             return true;
>> +             }
>> +             /* new pair is unknown, add it to the list */
>> +             if (freq_a != 0 && freq_b != 0) {
>> +                     mapped_af_index = (mapped_af_index+1 >= MAX_TMC_AF_CNT)? 0 : mapped_af_index + 1;
>> +                     afi->mapped_af[mapped_af_index] = freq_b;
>> +                     afi->mapped_af_tuning[mapped_af_index] = freq_a;
>> +                     afi->mapped_af_size++;
>> +             }
>> +             /* update the information in the handle */
>> +             afi->mapped_af_index = mapped_af_index;
>> +             if (afi->mapped_af_size >= MAX_TMC_AF_CNT)
>> +                     afi->mapped_af_size = MAX_TMC_AF_CNT;
>> +
>> +             return true;
>> +     }
>> +     return false;
>> +}
>> +
>>  /* adds one char of the ps name to temporal storage, the value is validated
>>   * if it is received twice in a row
>>   * @pos:     position of the char within the PS name (0..7)
>> @@ -968,13 +1120,12 @@ static uint32_t rds_decode_group8(struct rds_private_state *priv_state)
>>               !(grp->data_b_lsb & V4L2_TMC_TUNING_INFO)) {
>>               return rds_decode_tmc_multi_group(priv_state);
>>       }
>> -     /* -> tuning information message, defined for variants 4..9, submitted
>> -      * in bits 0-3 of block 2 */
>> +     /* -> tuning information message, defined for variants 4..9,
>> +      * submitted in bits 0-3 of block 2 */
>>       tuning_variant = grp->data_b_lsb & 0x0f;
>>       if ((grp->data_b_lsb & V4L2_TMC_TUNING_INFO) && tuning_variant >= 4 &&
>>               tuning_variant <= 9) {
>> -             /* TODO: Implement tuning information decoding */
>> -             return 0;
>> +             return rds_decode_tmc_tuning(priv_state);
>>       }
>>
>>       return 0;
>>
>
> I suggest that we update V4L2_RDS_VERSION to 2.
>
> Unless I am mistaken we are now complete with regards to the RDS/TMC
> functionality and we can release the library officially.
>
> It would still be nice if rds-ctl could decode the TMC messages to human
> readable text, though...
>
> Regards,
>
>         Hans
